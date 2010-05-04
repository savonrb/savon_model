require "spec"
require "savon_model"

class User < Savon::Model
  attr_accessor :id, :name, :email
end
