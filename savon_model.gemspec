lib = File.expand_path("../lib/", __FILE__)
$:.unshift lib unless $:.include?(lib)

require "savon_model"

Gem::Specification.new do |s|
  s.name = "savon_model"
  s.version = Savon::Model::VERSION
  s.authors = "Daniel Harrington"
  s.email = "me@rubiii.com"
  s.homepage = "http://github.com/rubiii/#{s.name}"
  s.summary = "SOAP model"
  s.description = "Model for SOAP service oriented applications."

  s.rubyforge_project = s.name

  s.add_development_dependency "savon", "~> 0.8.0.alpha.1"

  s.add_development_dependency "rspec", "~> 2.0.0"
  s.add_development_dependency "mocha", "~> 0.9.8"

  s.files = `git ls-files`.split("\n")
  s.require_path = "lib"
end
