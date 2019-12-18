# frozen_string_literal: true

module Lite
  module Component
    class Base
      include ActionView::Context
      include ActionView::Helpers

      attr_reader :context, :options
      attr_accessor :iteration

      def initialize(context, options = {})
        @context = context
        @options = default_options.deep_merge(options)
      end

      alias helpers context
      alias h helpers

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

      def iteration
        @iteration ||= Lite::Component::Iteration.new(nil, 1, 0)
      end

      alias i iteration

      def locals
        @locals ||= Lite::Component::Locals.new(options[:locals])
      end

      alias l locals

      def render
        collection = options.delete(:collection)
        return context.render(options) if collection.nil? || !collection.respond_to?(:to_a)

        Lite::Component::Collection.render(
          collection,
          component: self,
          spacer_template: options.delete(:spacer_template)
        )
      end

      def to_partial_path
        "components/#{self.class.component_name}"
      end

      private

      def default_options
        {
          partial: to_partial_path,
          object: self,
          as: :component,
          locals: { iteration: iteration }
        }
      end
    end
  end
end
