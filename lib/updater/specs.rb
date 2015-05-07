require 'fileutils'

class Specs
  attr_reader :path, :whitelist, :specs_root

  def initialize(path:, whitelist: [], specs_root: '')
    @path = path
    @whitelist = whitelist
    @specs_root = File.join(@path, specs_root)
  end

  def pods
    @pods ||= Dir.glob(File.join(@specs_root, '*')).map do |pod_path|
      pod = Pod.new(path: pod_path)
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
    @git ||= Git.new(path: @path)
  end

end