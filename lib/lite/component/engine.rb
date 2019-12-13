# frozen_string_literal: true

require 'rails/engine'

module Lite
  module Component
    class Engine < ::Rails::Engine

      initializer('lite-component.setup', group: :all) do |app|
        app.paths['config'] << File.join(config.root, 'app')
        app.paths['config'] << File.join(config.root, 'vendor')
      end

      initializer('lite-component.asset_path') do |app|
        app.config.assets.paths << Lite::Component.path if app.config.respond_to?(:assets)
      end

      initializer('lite-component.view_paths') do
        ActiveSupport.on_load(:action_controller) do
          append_view_path Lite::Component.path
        end
      end

    end
  end
end
