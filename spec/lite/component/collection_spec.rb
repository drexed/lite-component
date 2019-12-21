# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lite::Component::Collection do

  describe '.render' do
    context 'when collection is an array' do
      it 'to be "content-" 3 times' do
        component = Component.new(view, collection: [123, 456, 789])

        expect(component.render).to eq('content-content-content-')
      end
    end

    context 'when collection is an hash' do
      it 'to be "content-" 2 times' do
        component = Component.new(view, collection: { a: 1, b: 2 })

        expect(component.render).to eq('content-content-')
      end
    end
  end

end
