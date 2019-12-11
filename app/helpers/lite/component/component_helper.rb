# frozen_string_literal: true

module Lite
  module Component
    module ComponentHelper

      def component(name, attrs = nil, &block)
        name = name.component_name if name.respond_to?(:component_name)
        klass = "#{name}_component".classify.safe_constantize.new(self, attrs, &block)
        klass.render
      end

    end
  end
end
