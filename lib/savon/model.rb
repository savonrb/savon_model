require "savon"

module Savon

  # = Savon::Model
  #
  # Model for SOAP service oriented applications.
  module Model

    def self.handle_response=(recipe)
      @handle_response = recipe
    end

    def self.handle_response
      @handle_response
    end

    module ClassMethods

      def self.extend_object(base)
        super
        base.init_savon_model
      end

      def init_savon_model
        class_action_module
        instance_action_module
      end

      # Accepts one or more SOAP actions and generates both class and instance methods named
      # after the given actions. Each generated method accepts an optional SOAP body Hash and
      # a block to be passed to <tt>Savon::Client#request</tt> and executes a SOAP request.
      def actions(*actions)
        actions.each do |action|
          define_class_action action
          define_instance_action action
        end
      end

    private

      def define_class_action(action)
        class_action_module.module_eval <<-CODE
          def #{action.to_s.snakecase}(body = nil, &block)
            response = client.request :wsdl, #{action.inspect}, :body => body, &block
            Savon::Model.handle_response ? Savon::Model.handle_response.call(response) : response
          end
        CODE
      end

      def define_instance_action(action)
        instance_action_module.module_eval <<-CODE
          def #{action.to_s.snakecase}(body = nil, &block)
            self.class.#{action.to_s.snakecase} body, &block
          end
        CODE
      end

      def class_action_module
        @class_action_module ||= Module.new do

          def client(&block)
            @client ||= Savon::Client.new &block
          end

          def endpoint(uri)
            client.wsdl.endpoint = uri
          end

          def namespace(uri)
            client.wsdl.namespace = uri
          end

        end.tap { |mod| extend mod }
      end

      def instance_action_module
        @instance_action_module ||= Module.new do

          def client(&block)
            self.class.client &block
          end

          def endpoint(uri)
            self.class.endpoint uri
          end

          def namespace(uri)
            self.class.namespace uri
          end

        end.tap { |mod| include mod }
      end

    end

    def self.included(base)
      base.extend ClassMethods
    end

  end
end
