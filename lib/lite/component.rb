# frozen_string_literal: true

require 'action_view' unless defined?(ActionView)

require 'generators/rails/component_generator' if defined?(Rails::Generators)

require "lite/component/engine" if defined?(Rails::Engine)
require "lite/component/version"
require "lite/component/iteration"
require "lite/component/locals"
require "lite/component/base"
