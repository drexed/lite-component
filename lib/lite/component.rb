# frozen_string_literal: true

%w[version application engine element base].each do |filename|
  require "lite/component/#{filename}"
end

require 'generators/install_generator'
