# frozen_string_literal: true

module Lite
  module Component
    class Collection
      attr_reader :collection, :component, :spacer_template

      def initialize(collection, component:, spacer_template: nil)
        @collection = collection
        @component = component
        @spacer_template = spacer_template
      end

      class << self
        def render(collection, component)
          klass = new(collection, component)
          klass.render
        end
      end

      def render
        component.context.safe_join(iterated_collection)
      end

      private

      def collection_size
        @collection_size ||= collection.size
      end

      def iterated_collection
        collection.each_with_object([]).with_index do |(object, array), index|
          component.iteration = Lite::Component::Iteration.new(collection_size, index)
          component.options.deep_merge!(locals: { object: object, iteration: component.iteration })

          array << component.render_content
          next unless spacer_template && !component.iteration.last?

          array << component.context.render(spacer_template)
        end
      end
    end
  end
end
