# frozen_string_literal: true

module Lite
  module Component
    class Base < Lite::Component::Element

      def self.model_name
        ActiveModel::Name.new(Lite::Component::Base)
      end

      def self.component_name
        name.chomp('Component').demodulize.underscore
      end

      def self.component_path
        name.chomp('Component').underscore
      end

      def render
        @view.render partial: to_partial_path, object: self
      end

      def to_partial_path
        [self.class.component_path, self.class.component_name].join('/')
      end

    end
  end
end
