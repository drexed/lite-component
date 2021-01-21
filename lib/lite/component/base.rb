# frozen_string_literal: true

module Lite
  module Component
    class Base

      include ActionView::Context
      include ActionView::Helpers

      attr_accessor :components
      attr_reader :context, :iteration, :options

      # rubocop:disable Layout/LineLength
      def initialize(context, options = {}, &block)
        @components = []
        @iteration = (options[:locals] || {}).delete(:iteration) || Lite::Component::Iteration.new(1, 0)

        @context = context
        @options = default_options.deep_merge(options)

        yield(self) if block
      end
      # rubocop:enable Layout/LineLength

      alias helpers context
      alias c context
      alias h helpers
      alias i iteration

      class << self

        def build(name)
          return name if name.respond_to?(:component_path)

          "#{name}_component".classify.constantize
        end

        def component_name
          component_path.split('/').last
        end

        def component_path
          name.underscore.sub('_component', '')
        end

        def render(context, options = {}, &block)
          klass = new(context, options, &block)
          klass.render
        end

      end

      def add(name, options = {}, &block)
        components << [name, options, block]
      end

      def locals
        @locals ||= Lite::Component::Locals.new(options[:locals])
      end

      alias l locals

      def render
        return unless render?

        collection = options.delete(:collection)
        return render_collection(collection) if collection.respond_to?(:each)

        render_content
      end

      def render?
        true
      end

      def render_content
        context.render(options)
      end

      def to_partial_path
        "components/#{self.class.component_path}"
      end

      def yield
        context.safe_join(yield_content)
      end

      private

      def default_options
        {
          partial: to_partial_path,
          object: self,
          as: :component,
          locals: {
            c: self,
            object: nil,
            iteration: iteration
          }
        }
      end

      # rubocop:disable Metrics/AbcSize
      def render_collection(collection)
        collection_size = collection.size
        spacer_template = options.delete(:spacer_template)

        results = collection.each_with_object([]).with_index do |(item, array), index|
          array << context.render(spacer_template) if index.positive? && spacer_template
          iteration = Lite::Component::Iteration.new(collection_size, index)
          instance = self.class.new(context, locals: { object: item, iteration: iteration })
          array << instance.render
        end

        context.safe_join(results)
      end
      # rubocop:enable Metrics/AbcSize

      def yield_content
        components.map do |name, options, block|
          klass = self.class.build(name)
          klass.render(context, options, &block)
        end
      end

    end
  end
end
