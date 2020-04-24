# frozen_string_literal: true

module Lite
  module Component
    class Locals

      attr_reader :locals

      alias to_hash locals
      alias to_h locals

      def initialize(locals)
        @locals = (locals || {}).symbolize_keys
      end

      private

      def method_missing(method_name, *arguments, &block)
        if locals.key?(method_name)
          locals[method_name]
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        locals.key?(method_name) || super
      end

    end
  end
end
