# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lite::Component::Base do

  describe '#build' do
    it 'to be "nested/sample" when class given' do
      expect(described_class.build(Nested::SampleComponent)).to eq(Nested::SampleComponent)
    end

    it 'to be "nested/sample" when string given' do
      expect(described_class.build('nested/sample')).to eq(Nested::SampleComponent)
    end
  end

  describe '#component_name' do
    it 'to be "sample"' do
      expect(Nested::SampleComponent.component_name).to eq('sample')
    end
  end

  describe '#component_path' do
    it 'to be "nested/component"' do
      expect(Nested::SampleComponent.component_path).to eq('nested/sample')
    end
  end

  describe '.render' do
    context 'when a single item' do
      it 'to be "(0)content=-"' do
        component = Nested::SampleComponent.new(view)

        expect(component.render).to eq('(0)content=-')
      end

      it 'to be "<b>james</b>"' do
        component = Nested::SampleComponent.new(view, locals: { name: 'james' })

        def component.render_content
          message
        end

        expect(component.render).to eq('<b>james</b>')
      end
    end

    context 'when collection is an array' do
      it 'to be "(0)content=123-(1)content=456-(2)content=789-"' do
        component = Nested::SampleComponent.new(view, collection: [123, 456, 789])

        expect(component.render).to eq('(0)content=123-(1)content=456-(2)content=789-')
      end
    end

    context 'when collection is an hash' do
      it 'to be "(0)content=a.1-(1)content=b.2-"' do
        component = Nested::SampleComponent.new(view, collection: { a: 1, b: 2 })

        expect(component.render).to eq('(0)content=a.1-(1)content=b.2-')
      end
    end
  end

  describe '.render?' do
    it 'to be nil' do
      component = Nested::SampleComponent.new(view)

      def component.render?
        false
      end

      expect(component.render).to eq(nil)
    end
  end

  describe '.yield' do
    it 'to be "(0)content=-"' do
      component = Nested::SampleComponent.new(view, locals: { name: 'james' }) do |c|
        c.add(Nested::SampleComponent)
      end

      expect(component.yield).to eq('(0)content=-')
    end
  end

end
