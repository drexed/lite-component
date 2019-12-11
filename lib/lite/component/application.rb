# frozen_string_literal: true

module Lite
  module Component

    def self.names
      Dir.chdir(path) do
        Dir.glob('**/*_component.rb').map { |component| component.chomp('_component.rb') }.sort
      end
    end

    def self.path
      Rails.root.join('app/components')
    end

  end
end
