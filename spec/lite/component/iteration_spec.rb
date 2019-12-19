# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lite::Component::Iteration do
  let(:klass) { described_class.new(1, 0) }

  describe '.first?' do
    it 'to be true' do
      expect(klass.first?).to eq(true)
    end
  end

  describe '.last?' do
    it 'to be true' do
      expect(klass.last?).to eq(true)
    end
  end

end
