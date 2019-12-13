# frozen_string_literal: true

module Lite
  module Component
    class Base < Lite::Component::Element

      class << self

        def component_name
          component_path.split('/').last
        end

        def component_path
          name.chomp('Component').underscore
        end

        def model_name
          ActiveModel::Name.new(Lite::Component::Base)
        end

      end

      def render
        context.render(partial: to_partial_path, object: self)
      end

      def to_partial_path
        "components/#{self.class.component_path}"
      end

    end
  end
end
