require "savon/model_methods/mass_assignment"
require "savon/model_methods/client"

require "active_model"

module Savon

  # = Savon::Model
  # ==== Model for SOAP service oriented applications
  #
  # Savon::Model uses ActiveModel (introduced by Rails 3) and the Savon SOAP client library to create a pretty basic
  # layer for working with service oriented applications. The intention is to create models that look like they're
  # attached to a database, but use webservices to do the heavy lifting.
  class Model
    include Savon::ModelMethods::MassAssignment
    include Savon::ModelMethods::Client
    include ActiveModel::Validations
  end

end
