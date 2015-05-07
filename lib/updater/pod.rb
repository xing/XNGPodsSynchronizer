class Pod
  attr_reader :path, :name

  def initialize(path:)
    @path = path
    @name = @path.split(File::SEPARATOR).last
  end

  def versions
    @versions ||= Dir.glob(File.join(@path, '*')).map do |version_path| 
      Version.new(path: version_path)
    end
  end

  def git_source
    versions.sort.last.contents["source"]["git"]
  end

  def save
    versions.each(&:save)
  end

  def git
    @git ||= Git.new(path: @path)
  end

end