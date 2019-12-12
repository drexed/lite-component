# frozen_string_literal: true

module Lite
  module Component
    module ComponentHelper

      def component(name, attrs = nil, &block)
        name = name.component_path if name.respond_to?(:component_path)
        klass = "#{name}_component".classify.constantize.new(self, attrs, &block)
        klass.render
      end

    end
  end
end
