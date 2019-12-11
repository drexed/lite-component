# frozen_string_literal: true

module Lite
  module Component

    class Error < StandardError; end

    def self.names
      Dir.chdir(path) do
        Dir.glob('**/*_component.rb').map { |name| name.chomp('_component.rb') }
      end
    end

    def self.path
      Rails.root.join('app/components')
    end

  end
end
