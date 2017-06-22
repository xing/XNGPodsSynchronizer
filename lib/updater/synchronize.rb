require 'open-uri'
require 'openssl'
require 'net/http'
require 'json'

module PodSynchronize
  class Command
    class Synchronize < Command
      self.command = 'synchronize'
      self.summary = 'Synchronize the public CocoaPods repository with your mirror'

      self.arguments = [
        CLAide::Argument.new('CONFIG', :true),
      ]

      def initialize(argv)
        @yml_path = argv.shift_argument
      end

      def validate!
        raise Informative, "Please specify a valid CONFIG path" unless @yml_path
      end

      def setup(temp_path)
        @config = Configuration.new(@yml_path)
        @master_specs = Specs.new(File.join(temp_path, 'master'), dependencies, 'Specs')
        @internal_specs = Specs.new(File.join(temp_path, 'local'), [], '.')
      end

      def bootstrap
        @internal_specs.git.clone(@config.mirror.specs_push_url)
        @master_specs.git.clone(@config.master_repo, '. --depth 1')
      end

      def update_specs
        @internal_specs.merge_pods(@master_specs.pods)

        @internal_specs.pods.each do |pod|
          pod.versions.each do |version|
            if version.contents["source"]["git"]
              version.contents["source"]["git"] = "#{@config.mirror.source_clone_url}/#{pod.name}.git"
            end
          end
          pod.save
        end
        @internal_specs.git.commit(commit_message)
        @internal_specs.git.push
      end

      def commit_message
        time_str = Time.now.strftime('%c')
        "Update #{time_str}"
      end

      def update_sources(temp_path)
        @master_specs.pods.each do |pod|
          pod.git.path = File.join(temp_path, 'source_cache', pod.name)
          pod.git.clone(pod.git_source, ". --bare")
          pod.git.create_github_repo(
            @config.mirror.github.access_token,
            @config.mirror.github.organisation,
            pod.name,
            @config.mirror.github.endpoint
          )
          pod.git.set_origin("#{@config.mirror.source_push_url}/#{pod.name}.git")
          pod.git.push(nil, '--mirror')
        end
      end

      def dependencies
        pods_dependencies = []

        @config.api_podfiles.each do |podfile|
          podfile_contents = download_podfile(podfile)
          pods_dependencies << YAML.load(podfile_contents)["SPEC CHECKSUMS"].keys
        end

        @config.podfiles.each do |podfile|
          podfile_contents = open(podfile, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}) { |io| io.read }
          pods_dependencies << YAML.load(podfile_contents)["SPEC CHECKSUMS"].keys
        end
        pods_dependencies << @config.pods
        
        pods_dependencies.flatten!.uniq!

        pods_dependencies.reject! { |dependency| @config.excluded_pods.include? dependency } unless @config.excluded_pods.nil?

        pods_dependencies
      end

      def run
        Dir.mktmpdir do |dir|
          self.setup(dir)
          self.bootstrap
          self.update_specs
          self.update_sources(dir)
        end
      end

      private
        def get_download_url(url, access_token)
          result = `/usr/bin/curl #{url} -H "Authorization: token #{@config.mirror.github.access_token}"`
          JSON.parse(result)["download_url"]
        end

        def download_podfile(podfile)
          url = "#{@config.mirror.github.endpoint}/repos/#{podfile.org}/#{podfile.repo}/contents/#{podfile.path}"
          download_url = get_download_url(url, @config.mirror.github.access_token)
          `/usr/bin/curl #{download_url} -H "Authorization: token #{@config.mirror.github.access_token}"`
        end
    end
  end
end
