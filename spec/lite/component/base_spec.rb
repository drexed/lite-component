# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lite::Component::Base do

  describe '#component_name' do
    it 'to be "component"' do
      expect(Nested::Component.component_name).to eq('component')
    end
  end

  describe '#component_path' do
    it 'to be "nested/component"' do
      expect(Nested::Component.component_path).to eq('nested/component')
    end
  end

  describe '.render' do
    it 'to be "content-"' do
      component = Nested::Component.new(view)

      expect(component.render).to eq('content-')
    end

    it 'to be "<b>james</b>"' do
      component = Nested::Component.new(view, locals: { name: 'james' })

      def component.render_content
        message
      end

      expect(component.render).to eq('<b>james</b>')
    end
  end

end
