# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rails::ComponentGenerator, type: :generator do
  destination(File.expand_path('../../tmp', __FILE__))
  arguments %w[sample/test]

  before do
    prepare_destination
    run_generator
  end

  let(:js_sample_path) do
    'vendor/assets/javascripts/lite-frontend.js'
  end
  let(:css_sample_path) do
    'vendor/assets/stylesheets/lite-frontend/modes/web.scss'
  end

  describe '#generator' do
    it 'to be true when javascript file exists' do
      path = 'spec/generators/tmp/app/assets/javascripts/components/sample/test.js'

      expect(File.exist?(path)).to eq(true)
    end

    it 'to be true when stylesheet file exists' do
      path = 'spec/generators/tmp/app/assets/stylesheets/components/sample/test.scss'

      expect(File.exist?(path)).to eq(true)
    end

    it 'to be true when component file exists' do
      path = 'spec/generators/tmp/app/components/sample/test_component.rb'

      expect(File.exist?(path)).to eq(true)
    end

    it 'to be true when erb file exists' do
      path = 'spec/generators/tmp/app/views/components/sample/_test.html.erb'

      expect(File.exist?(path)).to eq(true)
    end
  end

end
