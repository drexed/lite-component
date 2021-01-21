# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lite::Component::Collection do

  describe '.render' do
    context 'when collection is an array' do
      it 'to be "content-" 3 times' do
        component = Nested::SampleComponent.new(view, collection: [123, 456, 789])

        expect(component.render).to eq('content:123-content:456-content:789-')
      end
    end

    context 'when collection is an hash' do
      it 'to be "content-" 2 times' do
        component = Nested::SampleComponent.new(view, collection: { a: 1, b: 2 })

        expect(component.render).to eq('content:a.1-content:b.2-')
      end
    end
  end

end
