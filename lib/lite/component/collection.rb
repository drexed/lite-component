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

      # rubocop:disable Metrics/LineLength
      def iterated_collection
        collection.each_with_object([]).with_index do |(object, array), index|
          iteration = Lite::Component::Iteration.new(object, collection_size, index)

          array << component.context.render(component.options.deep_merge(locals: { iteration: iteration }))
          array << component.context.render(spacer_template) if spacer_template && !iteration.last?
        end
      end
      # rubocop:enable Metrics/LineLength
    end
  end
end
