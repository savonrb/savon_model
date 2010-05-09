module Savon
  module ModelMethods
    module MassAssignment

      # Accepts a Hash of +attributes+ and assigns them via writer methods.
      # Every attribute assigned needs to have a writer method.
      def initialize(attributes = {})
        attributes.each { |key, value| send "#{key}=", value }
      end

    end
  end
end
