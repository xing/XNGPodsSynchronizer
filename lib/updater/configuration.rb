require 'yaml'
require 'erb'

class Configuration
  attr_reader :yaml
  Mirror = Struct.new(:specs_push_url, :source_push_url, :source_clone_url, :github)
  Github = Struct.new(:access_token, :organisation, :endpoint)

  def initialize(path)
    @yaml = YAML.load(ERB.new(File.new(path).read).result)
  end

  def master_repo
    @yaml['master_repo']
  end

  def podfiles
    @yaml['podfiles']
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

  private

  def github
    context = @yaml['mirror']['github']
    Github.new(
      context['acccess_token'],
      context['organisation'],
      context['endpoint'])
  end

end
