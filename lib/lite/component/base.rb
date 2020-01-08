# frozen_string_literal: true

module Lite
  module Component
    class Base

      include ActionView::Context
      include ActionView::Helpers

      attr_accessor :components
      attr_reader :context, :options
      attr_writer :iteration

      def initialize(context, options = {}, &block)
        @context = context
        @options = default_options.deep_merge(options)

        @components = []

        yield(self) if block_given?
      end

      alias helpers context
      alias c context
      alias h helpers

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

      def add(name, options = {})
        components << [name, options]
      end

      def iteration
        @iteration ||= Lite::Component::Iteration.new(1, 0)
      end

      alias i iteration

      def locals
        @locals ||= Lite::Component::Locals.new(options[:locals])
      end

      alias l locals

      def render
        collection = options.delete(:collection)
        return render_content if collection.nil? || !collection.respond_to?(:each)

        Lite::Component::Collection.render(
          collection,
          component: self,
          spacer_template: options.delete(:spacer_template)
        )
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

      def yield_content
        components.map do |name, options|
          klass = self.class.build(name)
          klass.render(context, options)
        end
      end

    end
  end
end
