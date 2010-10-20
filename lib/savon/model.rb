require "savon"
require "savon/ext/response"

module Savon
  module Model

    VERSION = "0.1.0"

    class << self

      def response_pattern
        @response_pattern ||= []
      end

      attr_writer :response_pattern

    end

    module ClassMethods

      def client(&block)
        @client ||= Savon::Client.new &block
      end

      def endpoint(uri)
        client.wsdl.endpoint = uri
      end

      def namespace(uri)
        client.wsdl.namespace = uri
      end

      def actions(*args)
        args.each do |arg|
          define_class_action arg
          define_instance_action arg
        end
      end

    private

      def define_class_action(action)
        self.class.send :define_method, action do |body|
          client.request :wsdl, action, :body => body
        end
      end

      def define_instance_action(action)
        define_method action do |body|
          self.class.send action, body
        end
      end

    end

    def self.included(base)
      base.extend ClassMethods
    end

    def client
      self.class.client
    end

  end
end
