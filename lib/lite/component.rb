# frozen_string_literal: true

%w[version engine iteration collection locals base].each do |filename|
  require "lite/component/#{filename}"
end

require 'generators/component_generator'
