# frozen_string_literal: true

require 'rails/engine'

module Lite
  module Component
    class Engine < ::Rails::Engine

      initializer('lite-component.setup', group: :all) do |app|
        app.paths['config'] << File.join(config.root, 'app')
      end

    end
  end
end
