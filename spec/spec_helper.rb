require "bundler"
Bundler.require :default, :test
#require "rspec"
#require "mocha"

RSpec.configure do |config|
  config.mock_with :mocha
end
