# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lite::Component::Locals do
  let(:klass) { described_class.new('color' => 'red') }

  describe '.method_missing' do
    it 'to be "red"' do
      expect(klass.color).to eq('red')
    end

    it 'to raise a NoMethodError' do
      expect { klass.size }.to raise_error(NoMethodError)
    end
  end

  describe '.respond_to' do
    it 'to be true' do
      expect(klass.respond_to?(:color)).to eq(true)
    end

    it 'to be false' do
      expect(klass.respond_to?(:size)).to eq(false)
    end
  end

end
