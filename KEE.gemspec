# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'KEE/version'

Gem::Specification.new do |spec|
  spec.name          = 'kee'
  spec.version       = Kee::VERSION
  spec.authors       = ['The Ship Network']
  spec.email         = ['hassoun@outlook.com']
  spec.summary       = %q{}
  spec.description   = %q{Key Element Extraction script.}
  spec.homepage      = 'http://theshipnetwork.herokuapp.com/'
  spec.license       = ''

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency 'gmail', '~> 0.5.0' # https://github.com/gmailgem/gmail
end
