# frozen_string_literal: true

require 'action_view'

%w[version engine iteration locals base].each do |filename|
  require "lite/component/#{filename}"
end

require 'generators/rails/component_generator'
