require 'yaml'
require 'erb'

class Configuration
  attr_reader :yaml
  Mirror = Struct.new(:specs_push_url, :source_push_url, :source_clone_url, :github)
  Github = Struct.new(:access_token, :organisation, :endpoint)
  APIPodfile = Struct.new(:org, :repo, :path)

  def initialize(path)
    @yaml = YAML.load(ERB.new(File.new(path).read).result)
  end

  def master_repo
    @yaml['master_repo']
  end

  def podfiles
    @yaml['podfiles'] || []
  end

  def pods
    @yaml['pods']
  end

  def excluded_pods
    @yaml['excluded_pods']
  end

  def mirror
    context = @yaml['mirror']
    Mirror.new(
      context['specs_push_url'],
      context['source_push_url'],
      context['source_clone_url'],
      github)
  end

  def api_podfiles
    context = @yaml['api_podfiles'] || []
    podfiles = context.map do |podfile|
      APIPodfile.new(
        podfile['org'],
        podfile['repo'],
        podfile['path']
        )
    end
  end

  private

  def github
    context = @yaml['mirror']['github']
    Github.new(
      context['acccess_token'],
      context['organisation'],
      context['endpoint'])
  end

end
