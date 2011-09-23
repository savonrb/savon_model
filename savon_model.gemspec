# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "savon/model_version"

Gem::Specification.new do |s|
  s.name        = "savon_model"
  s.version     = Savon::Model::VERSION
  s.authors     = "Daniel Harrington"
  s.email       = "me@rubiii.com"
  s.homepage    = "http://github.com/rubiii/#{s.name}"
  s.summary     = "Model for SOAP service oriented applications"
  s.description = s.summary

  s.rubyforge_project = s.name

  s.add_dependency "httpi", ">= 0.7.8"
  s.add_dependency "savon", ">= 0.8.2"

  s.add_development_dependency "rake",  "~> 0.8.7"
  s.add_development_dependency "rspec", "~> 2.6.0"
  s.add_development_dependency "mocha", "~> 0.10.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
