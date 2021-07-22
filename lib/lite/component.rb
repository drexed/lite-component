# frozen_string_literal: true

require 'action_view' unless defined?(ActionView)

require 'generators/rails/component_generator' if defined?(Rails::Generators)

%w[version engine iteration locals base].each do |filename|
  require "lite/component/#{filename}"
end
