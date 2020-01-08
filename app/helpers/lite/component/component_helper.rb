# frozen_string_literal: true

module Lite
  module Component
    module ComponentHelper

      def component(name, options = {}, &block)
        klass = Lite::Component::Base.build(name)
        klass.render(self, options, &block)
      end

    end
  end
end
