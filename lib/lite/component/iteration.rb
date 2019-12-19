# frozen_string_literal: true

module Lite
  module Component
    class Iteration

      attr_reader :index, :size

      def initialize(size, index)
        @size = size
        @index = index
      end

      def first?
        index.zero?
      end

      def last?
        index == (size - 1)
      end

    end
  end
end
