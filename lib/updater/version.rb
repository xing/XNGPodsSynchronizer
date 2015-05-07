require 'json'

class Version
  attr_reader :path, :version
  attr_accessor :contents

  def initialize(path:)
    @path = path
    @version = @path.split(File::SEPARATOR).last
    @contents = fetch_podspec
  end

  def save
    File.write(podspec_path, JSON.pretty_generate(@contents))
  end

  def <=>(other)
    own_version = @version.split('.').map(&:to_i)
    other_version = other.version.split('.').map(&:to_i)
    own_version <=> other_version
  end

  private 

    def podspec_path
      filepath = Dir.glob(File.join(@path, '*')).first
      unless filepath.end_with? 'podspec.json'
        raise "Couldn't find podspec file, got #{filepath}"
      end
      filepath
    end

    def fetch_podspec
      file = File.read(podspec_path)
      JSON.parse(file)
    end

end