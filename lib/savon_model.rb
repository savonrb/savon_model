require "savon"
require "active_model"

module Savon

  # = Savon::Model
  # ==== Model for SOAP service oriented applications
  #
  # Savon::Model uses ActiveModel (introduced by Rails 3) and the Savon SOAP client library to create a pretty
  # basic layer for working with service oriented applications. The intention is to create models that look like
  # they're attached to a database, but use webservices to do the heavy lifting.
  class Model
    include ActiveModel::Validations

    # Reader/writer method for specifying and retrieving Savon::Client objects.
    #
    # === Writer
    #
    # Let's you specify a Savon::Client with a given +name+ that you can retrieve
    # at both class and instance levels. Needs to be called with a Hash of +options+
    # including the SOAP +endpoint+ and +namespace+ of your service.
    #
    # === Reader
    #
    # Returns a Savon::Client previously stored under a given +name+.
    def self.client(name, options = {})
      @clients ||= {}
      
      unless options.empty?
        @clients[name] = Savon::Client.new options[:endpoint]
        Savon::SOAP.namespaces["xmlns:wsdl"] = options[:namespace]
      end
      
      @clients[name]
    end

    # Accepts a Hash of +attributes+ and assigns them as instance variables.
    def initialize(attributes = {})
      attributes.each { |key, value| instance_variable_set "@#{key}", value }
    end

    # Returns a Savon::Client by delegating to the +client+ class method.
    def client(name)
      self.class.client name
    end

  end
end
