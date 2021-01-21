# frozen_string_literal: true

module Nested
  class SampleComponent < Lite::Component::Base

    def message
      content_tag(:b, l.name)
    end

    def render_content
      value = Array(l.object).join('.')
      "content:#{value}-"
    end

  end
end

class View

  def capture(element)
    yield(element)
  end

  def safe_join(array)
    array.flatten.join
  end

end

module ContextHelper

  extend RSpec::SharedContext

  let(:view) { View.new }

end
