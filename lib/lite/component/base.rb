# frozen_string_literal: true

module Lite
  module Component
    class Base
      include ActionView::Context
      include ActionView::Helpers

      attr_reader :context, :options

      def initialize(context, options = {})
        @context = context
        @options = { partial: to_partial_path, object: self, as: :component }.merge(options)
      end

      class << self
        def component_name
          component_path.split('/').last
        end

        def component_path
          name.underscore.sub('_component', '')
        end

        def render(context, options = {})
          klass = new(context, options)
          klass.render
        end
      end

      def render
        collection = options.delete(:collection)
        return context.render(options) unless collection.respond_to?(:to_a)

        Lite::Component::Collection.render(
          collection,
          component: self,
          spacer_template: options.delete(:spacer_template)
        )
      end

      def to_partial_path
        "components/#{self.class.component_name}"
      end
    end
  end
end
