# frozen_string_literal: true

module Lite
  module Component
    module ComponentHelper

      def component(name, options = {})
        name = name.component_path if name.respond_to?(:component_path)
        "#{name}_component".classify.constantize.render(self, options)
      end

    end
  end
end
