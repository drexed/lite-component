# frozen_string_literal: true

module Lite
  module Component

    class Error < StandardError; end

    def self.names
      components_ext = '_component.rb'
      components_dir = "#{path}/"
      components_glob = path.join("**/*#{components_ext}")

      Dir.glob(components_glob).map { |name| name.sub(components_dir, '').chomp(components_ext) }
    end

    def self.path
      Rails.root.join('app/components')
    end

  end
end
