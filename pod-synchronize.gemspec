# coding: utf-8
Gem::Specification.new do |spec|
  spec.name         = "pod-synchronize"
  spec.version      = "0.5.0"
  spec.authors      = ["Matthias Männich", "Piet Brauer", "Renzo Crisostomo"]
  spec.email        = ["matthias.maennich@xing.com", "piet.brauer@xing.com", "renzo.crisostomo@xing.com"]
  spec.summary      = %q{Mirrors CocoaPods specs}
  spec.description  = %q{Synchronizes the public CocoaPods Specs repo with your internal mirror.}
  spec.homepage     = "https://github.com/xing/XNGPodsSynchronizer"
  spec.license      = "MIT"

  spec.files        = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "claide", "~> 0.8.1"
  spec.add_dependency "colored", "~> 1.2"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.required_ruby_version = '>= 2.0.0'
end
