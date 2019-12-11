# frozen_string_literal: true

module Lite
  module Component
    class Element

      include ActiveModel::Validations

      def initialize(view, attributes = nil, &block)
        initialize_attributes(attributes || {})
        initialize_elements

        @view = view
        @yield = block_given? ? @view.capture(self, &block) : nil

        validate!
      end

      class << self
        def attribute(name, default: nil)
          attributes[name] = { default: default }
          define_method_or_raise(name) { get_instance_variable(name) }
        end

        def attributes
          @attributes ||= {}
        end

        def element(name, multiple: false, &config)
          plural_name = name.to_s.pluralize.to_sym if multiple

          elements[name] = {
            multiple: plural_name || false,
            class: Class.new(Element, &config)
          }

          define_method_or_raise(name) do |attributes = nil, &block|
            return get_instance_variable(multiple ? plural_name : name) unless attributes || block

            element = self.class.elements[name][:class].new(@view, attributes, &block)

            if multiple
              get_instance_variable(plural_name) << element
            else
              set_instance_variable(name, element)
            end
          end

          return if !multiple || name == plural_name

          define_method_or_raise(plural_name) { get_instance_variable(plural_name) }
        end

        def elements
          @elements ||= {}
        end

        def model_name
          ActiveModel::Name.new(Lite::Component::Element)
        end

        private

        def define_method_or_raise(method_name, &block)
          if method_defined?(method_name.to_sym)
            raise Lite::Component::Error, "Method #{method_name.inspect} already exists"
          else
            define_method(method_name, &block)
          end
        end
      end

      def to_s
        @yield
      end

      protected

      def initialize_attributes(attributes)
        self.class.attributes.each do |name, options|
          set_instance_variable(
            name,
            attributes[name] || (options[:default] && options[:default].dup)
          )
        end
      end

      def initialize_elements
        self.class.elements.each do |name, options|
          if (plural_name = options[:multiple])
            set_instance_variable(plural_name, [])
          else
            set_instance_variable(name, nil)
          end
        end
      end

      private

      def get_instance_variable(name)
        instance_variable_get(:"@#{name}")
      end

      def set_instance_variable(name, value)
        instance_variable_set(:"@#{name}", value)
      end

    end
  end
end
