require 'open-uri'
require 'openssl'

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

      def setup(temp_path:)
        @config = Configuration.new(path: @yml_path)
        @master_specs = Specs.new(path: File.join(temp_path, 'master'), whitelist: dependencies, specs_root: 'Specs')
        @internal_specs = Specs.new(path: File.join(temp_path, 'local'), specs_root: '.')
      end

      def bootstrap
        @internal_specs.git.clone(url: @config.mirror.specs_push_url)
        @master_specs.git.clone(url: @config.master_repo, options: '. --depth 1')
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
        @internal_specs.git.commit(message: commit_message)
        @internal_specs.git.push
      end

      def commit_message
        time_str = Time.now.strftime('%c')
        "Update #{time_str}"
      end

      def update_sources(temp_path:)
        @master_specs.pods.each do |pod|
          pod.git.path = File.join(temp_path, 'source_cache', pod.name)
          pod.git.clone(url: pod.git_source, options: ". --bare")
          pod.git.create_github_repo(
            access_token: @config.mirror.github.access_token,
            org: @config.mirror.github.organisation,
            name: pod.name,
            endpoint: @config.mirror.github.endpoint
          )
          pod.git.set_origin(url: "#{@config.mirror.source_push_url}/#{pod.name}.git")
          pod.git.push(remote: nil, options: '--mirror')
        end
      end

      def dependencies
        pods_dependencies = []

        @config.podfiles.each do |podfile|
          podfile_contents = open(podfile, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}) { |io| io.read }
          pods_dependencies << YAML.load(podfile_contents)["SPEC CHECKSUMS"].keys
        end
        pods_dependencies << @config.pods
        
        pods_dependencies.flatten!.uniq!

        pods_dependencies.reject! { |dependency| @config.excluded_pods.include? dependency }
      end

      def run
        Dir.mktmpdir do |dir|
          self.setup(temp_path: dir)
          self.bootstrap
          self.update_specs
          self.update_sources(temp_path: dir)
        end
      end
    end
  end
end
