# frozen_string_literal: true

%w[version errors application engine element base].each do |filename|
  require "lite/component/#{filename}"
end

require 'generators/component_generator'
