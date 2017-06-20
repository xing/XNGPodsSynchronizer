require 'fileutils'

class Specs
  attr_reader :path, :whitelist, :specs_root

  def initialize(path, whitelist = [], specs_root = '')
    @path = path
    @whitelist = whitelist
    @specs_root = File.join(@path, specs_root)
  end

  def pods
    @pods ||= traverse(@specs_root).flatten.map do |pod_path|
      pod = Pod.new(pod_path)
      @whitelist.any? && !@whitelist.include?(pod.name) ? nil : pod
    end.compact
  end

  def merge_pods(other_pods)
    other_pods.each do |pod|
      FileUtils.cp_r(pod.path, @path)
    end
    @pods = nil
  end

  def git
    @git ||= Git.new(@path)
  end

  private

  def traverse(working_dir)
    whitelist = %w{0 1 2 3 4 5 6 7 8 9 a b c d e f}
    pods = []
    Dir.glob(File.join(working_dir, '*')).map do |dir|
      dir_name = dir.split(File::SEPARATOR).last
      if whitelist.include? dir_name
        pods << traverse(dir)
      else
        pods << dir
      end
    end
    pods
  end

end
