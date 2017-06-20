require 'uri'

class Pod
  attr_reader :path, :name

  def initialize(path)
    @path = path
    @name = @path.split(File::SEPARATOR).last
  end

  def versions
    @versions ||= Dir.glob(File.join(@path, '*')).map do |version_path| 
      Version.new(version_path)
    end
  end

  def git_source
    source = versions.sort.last.contents["source"]["git"]
    source ||= begin
      http_source = versions.sort.last.contents["source"]["http"]
      uri = URI.parse(http_source)
      host = uri.host.match(/www.(.*)/).captures.first
      scheme = "git"
      path = uri.path.split("/").take(3).join("/").concat(".git")
      URI::Generic.build({scheme: scheme, host: host, path: path}).to_s
    end
  end

  def save
    versions.each(&:save)
  end

  def git
    @git ||= Git.new(@path)
  end

end
