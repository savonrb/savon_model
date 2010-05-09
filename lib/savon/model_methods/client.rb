require "savon"

module Savon
  module ModelMethods
    module Client

      module ClassMethods

        # Reader/writer method for specifying and retrieving Savon::Client objects.
        #
        # === Writer
        #
        # Let's you specify a Savon::Client with a given +name+ that you can retrieve at both class and instance levels.
        # Needs to be called with a Hash of +options+ including the SOAP +endpoint+ and +namespace+ of your service.
        #
        # === Reader
        #
        # Returns a Savon::Client previously stored under a given +name+.
        def client(name, options = {})
          @clients ||= {}
          
          unless options.empty?
            @clients[name] = Savon::Client.new options[:endpoint]
            Savon::SOAP.namespaces["xmlns:wsdl"] = options[:namespace]
          end
          
          @clients[name]
        end
      end

      def self.included(base)
        base.extend ClassMethods
      end

      # Returns a Savon::Client by delegating to the +client+ class method.
      def client(name)
        self.class.client name
      end

    end
  end
end
