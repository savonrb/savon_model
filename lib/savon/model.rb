require "savon"

module Savon

  # = Savon::Model
  #
  # Model for SOAP service oriented applications.
  module Model

    VERSION = "0.3.0"

    module ClassMethods

      # Returns a memoized <tt>Savon::Client</tt> instance. Accepts a block and passes it
      # to <tt>Savon::Client.new</tt> when called for the first time.
      def client(&block)
        @@client ||= Savon::Client.new &block
      end

      # Sets the SOAP endpoint.
      def endpoint(uri)
        client.wsdl.endpoint = uri
      end

      # Sets the target namespace.
      def namespace(uri)
        client.wsdl.namespace = uri
      end

      # Accepts one or more SOAP actions and generates both class and instance methods named
      # after the given actions. Each generated method accepts an optional SOAP body Hash and
      # a block to be passed to <tt>Savon::Client#request</tt> and executes a SOAP request.
      def actions(*args)
        args.each do |arg|
          define_class_action arg
          define_instance_action arg
        end
      end

    private

      def define_class_action(action)
        instance_eval %Q{
          def #{action.to_s.snakecase}(body = nil, &block)
            client.request :wsdl, #{action.inspect}, :body => body, &block
          end
        }
      end

      def define_instance_action(action)
        class_eval %Q{
          def #{action.to_s.snakecase}(body = nil, &block)
            self.class.#{action.to_s.snakecase} body, &block
          end
        }
      end

    end

    def self.included(base)
      base.extend ClassMethods
    end

    # Returns a memoized <tt>Savon::Client</tt> instance.
    def client
      self.class.client
    end

  end
end
