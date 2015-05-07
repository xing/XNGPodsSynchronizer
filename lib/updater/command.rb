require 'claide'
require 'colored'

module PodSynchronize
  class PlainInformative < StandardError
      include CLAide::InformativeError
  end

  class Informative < PlainInformative
    def message
      "[!] #{super}".red
    end
  end

  class Command < CLAide::Command
    require "updater"

    self.abstract_command = true
    self.command = 'pod-synchronize'
    self.version = '0.1.0'
    self.description = 'Pods Synchronizer'
  end
end
