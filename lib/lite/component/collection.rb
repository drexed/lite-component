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
        @collection_size ||= begin
          if collection.respond_to?(:size)
            collection.size
          elsif collection.respond_to?(:to_a)
            collection.to_a.size
          elsif collection.respond_to?(:to_hash)
            collection.to_hash.size
          end
        end
      end

      # rubocop:disable Metrics/AbcSize
      def iterated_collection
        collection.each_with_object([]).with_index do |(object, array), index|
          component.iteration = Lite::Component::Iteration.new(collection_size, index)
          component.options.deep_merge!(locals: { object: object, iteration: component.iteration })
          content = component.render_content
          next if content.nil?

          array << content
          next unless spacer_template && !component.iteration.last?

          array << component.context.render(spacer_template)
        end
      end
      # rubocop:enable Metrics/AbcSize

    end
  end
end
