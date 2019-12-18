# frozen_string_literal: true

module Lite
  module Component
    class Locals
      attr_reader :locals

      def initialize(locals)
        @locals = (locals || {}).symbolize_keys
      end

      private

      def respond_to_missing?(method_name, include_private = false)
        locals.key?(method_name)
      end

      def method_missing(method_name, *arguments)
        if locals.key?(method_name)
          locals[method_name]
        else
          super
        end
      end
    end
  end
end
