require "savon"
require "savon/model"

module Savon
  module SOAP
    class Response

      # Returns the original result of <tt>Savon::SOAP::Response#to_hash</tt>.
      def new_hash
        @new_hash ||= response_pattern original_hash
      end

      alias_method :original_hash, :to_hash
      alias_method :to_hash, :new_hash

      # Returns the response Hash as an Array.
      def to_array
        @array ||= begin
          array = to_hash.kind_of?(Array) ? to_hash : [to_hash]
          array.compact
        end
      end

    private

      def response_pattern(hash)
        return hash if Model.response_pattern.blank?
        
        Model.response_pattern.inject(hash) do |memo, pattern|
          key = case pattern
            when Regexp then memo.keys.find { |key| key.to_s =~ pattern }
            else             memo.keys.find { |key| key.to_s == pattern.to_s }
          end
          
          return unless key
          memo[key]
        end
      end

    end
  end
end
