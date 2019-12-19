# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lite::Component::Collection do

  describe '.render' do
    it 'to be "content-" 3 times' do
      component = Component.new(view, collection: [123, 456, 789])

      expect(component.render).to eq('content-content-content-')
    end
  end

end
