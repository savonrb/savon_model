require "bundler"
Bundler.require :default, :test

RSpec.configure do |config|
  config.mock_with :mocha
end
