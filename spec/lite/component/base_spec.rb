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
    it 'to be "content-"' do
      component = Nested::SampleComponent.new(view)

      expect(component.render).to eq('content-')
    end

    it 'to be "<b>james</b>"' do
      component = Nested::SampleComponent.new(view, locals: { name: 'james' })

      def component.render_content
        message
      end

      expect(component.render).to eq('<b>james</b>')
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
    it 'to be "<b>james</b>"' do
      component = Nested::SampleComponent.new(view, locals: { name: 'james' }) do |c|
        c.add(Nested::SampleComponent)
      end

      def component.render_content
        message
      end

      expect(component.yield).to eq('content-')
    end
  end

end
