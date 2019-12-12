# frozen_string_literal: true

RSpec.describe Lite::Component::Base do
  let(:view_class) do
    Class.new do
      def capture(element)
        yield(element)
      end
    end
  end

  describe '#initialize' do
    it 'to be nil when no values given' do
      component_class = Class.new(described_class)
      component = component_class.new(view_class.new)

      expect(component.to_s).to be nil
    end

    it 'to be "foo" when block given' do
      component_class = Class.new(described_class)
      component = component_class.new(view_class.new) { 'foo' }

      expect(component.to_s).to eq('foo')
    end

    it 'to raise Lite::Component::BuildError when overwriting existing method with attribute' do
      expect do
        Class.new(described_class) do
          attribute :to_s
        end
      end.to raise_error(Lite::Component::BuildError, 'Method :to_s already exists')
    end

    it 'to be nil when attribute with no value' do
      component_class = Class.new(described_class) do
        attribute :foo
      end
      component = component_class.new(view_class.new)

      expect(component.foo).to be nil
    end

    it 'to be "foo" when attribute with value' do
      component_class = Class.new(described_class) do
        attribute :foo
      end
      component = component_class.new(view_class.new, foo: 'foo')

      expect(component.foo).to eq('foo')
    end

    it 'to be "foo" when attribute with default value' do
      component_class = Class.new(described_class) do
        attribute :foo, default: 'foo'
      end
      component = component_class.new(view_class.new)

      expect(component.foo).to eq('foo')
    end

    it 'to raise Lite::Component::BuildError when overwriting existing method with element' do
      expect do
        Class.new(described_class) do
          def foo
            'foo'
          end

          element :foo
        end
      end.to raise_error(Lite::Component::BuildError, 'Method :foo already exists')
    end

    it 'to be "foo" when element with block' do
      component_class = Class.new(described_class) do
        element :foo
      end
      component = component_class.new(view_class.new)
      component.foo { 'foo' }

      expect(component.foo.to_s).to eq('foo')
      expect(component.foo.render).to eq('foo')
    end

    it 'to be "baz" when element with attribute with value' do
      component_class = Class.new(described_class) do
        element :foo do
          attribute :bar
        end
      end
      component = component_class.new(view_class.new)
      component.foo(bar: 'baz')

      expect(component.foo.bar).to eq('baz')
    end

    it 'to be the value of each element with block with nested element with block' do
      component_class = Class.new(described_class) do
        element :foo do
          element :bar
        end
      end
      component = component_class.new(view_class.new)
      component.foo do |cc|
        cc.bar { 'bar' }

        'foo'
      end

      expect(component.foo.to_s).to eq('foo')
      expect(component.foo.bar.to_s).to eq('bar')
    end

    it 'to be the value of each element with multiple true' do
      component_class = Class.new(described_class) do
        element :foo, multiple: true
      end
      component = component_class.new(view_class.new)
      component.foo { 'foo' }
      component.foo { 'bar' }

      expect(component.foos.length).to eq(2)
      expect(component.foos[0].to_s).to eq('foo')
      expect(component.foos[1].to_s).to eq('bar')
    end

    # rubocop:disable Metrics/LineLength
    it 'to be the value of each element with multiple true when singular and plural name are the same' do
      component_class = Class.new(described_class) do
        element :foos, multiple: true
      end
      component = component_class.new(view_class.new)
      component.foos { 'foo' }
      component.foos { 'bar' }

      expect(component.foos.length).to eq(2)
      expect(component.foos[0].to_s).to eq('foo')
      expect(component.foos[1].to_s).to eq('bar')
    end
    # rubocop:enable Metrics/LineLength

    it 'to be nil when element is not set' do
      component_class = Class.new(described_class) do
        element :foo
      end
      component = component_class.new(view_class.new)

      expect(component.foo).to be nil
    end

    it 'to be nil when element with multiple true is not set' do
      component_class = Class.new(described_class) do
        element :foo, multiple: true
      end
      component = component_class.new(view_class.new)

      expect(component.foos).to eq([])
    end

    it 'to not raise error when element with multiple true is not set' do
      component_class = Class.new(described_class) do
        attribute :foo
        validates :foo, presence: true
      end

      expect do
        component_class.new(view_class.new, foo: 'bar')
      end.not_to raise_error
    end

    it 'to raise Lite::Component::ValidationError when without attribute and failing validation' do
      component_class = Class.new(described_class) do
        attribute :foo
        validates :foo, presence: true
      end

      expect do
        component_class.new(view_class.new)
      end.to raise_error(Lite::Component::ValidationError, "Validation failed: Foo can't be blank")
    end

    it 'to not raise error when with default value and successful validation' do
      component_class = Class.new(described_class) do
        attribute :foo, default: 'bar'
        validates :foo, presence: true
      end

      expect do
        component_class.new(view_class.new)
      end.not_to raise_error
    end

    it 'to not raise error when element and successful element validation' do
      component_class = Class.new(described_class) do
        element :foo
        validates :foo, presence: true
      end

      expect do
        component_class.new(view_class.new, {}) do |c|
          c.foo { 'foo' }
        end
      end.not_to raise_error
    end

    it 'to raise Lite::Component::ValidationError when element and failing element validation' do
      component_class = Class.new(described_class) do
        element :foo
        validates :foo, presence: true
      end

      expect do
        component_class.new(view_class.new, {})
      end.to raise_error(Lite::Component::ValidationError, "Validation failed: Foo can't be blank")
    end

    it 'to not raise error when element and successful element attribute validation' do
      component_class = Class.new(described_class) do
        element :foo do
          attribute :bar
          validates :bar, presence: true
        end
      end

      expect do
        component_class.new(view_class.new, {}) do |c|
          c.foo(bar: 'baz') { 'foo' }
        end
      end.not_to raise_error
    end

    # rubocop:disable Metrics/LineLength
    it 'to raise Lite::Component::ValidationError when element and failing element attribute validation' do
      component_class = Class.new(described_class) do
        element :foo do
          attribute :bar
          validates :bar, presence: true
        end
      end

      expect do
        component_class.new(view_class.new, {}) do |c|
          c.foo { 'foo' }
        end
      end.to raise_error(Lite::Component::ValidationError, "Validation failed: Bar can't be blank")
    end
    # rubocop:enable Metrics/LineLength
  end
end
