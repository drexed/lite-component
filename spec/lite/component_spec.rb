# frozen_string_literal: true

RSpec.describe Lite::Component do
  it 'to be a version number' do
    expect(Lite::Component::VERSION).not_to be nil
  end
end
