# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lite::Component::Base do

  describe '.render' do
    it 'to be "content-"' do
      component = Component.new(view)

      expect(component.render).to eq('content-')
    end

    it 'to be "<b>james</b>"' do
      component = Component.new(view, locals: { name: 'james' })

      def component.render_content
        message
      end

      expect(component.render).to eq('<b>james</b>')
    end
  end

end
