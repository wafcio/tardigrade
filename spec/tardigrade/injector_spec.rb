RSpec.describe Tardigrade::Injector do
  let(:service) { @service_class.new }

  before do
    Tardigrade.instance_variable_set(:@dependencies, nil)
    Tardigrade.add_dependency(:foo, dependency_class)

    @service_class = Class.new do
      include Tardigrade::Injector

      import :foo
    end
  end

  context "without arguments" do
    let(:dependency_class) do
      Class.new do
        def call
          :foo
        end
      end
    end

    it "allow to call .foo" do
      expect(service.foo).to eq(:foo)
    end
  end

  context "with single argument" do
    let(:dependency_class) do
      Class.new do
        def call(id)
          id
        end
      end
    end

    it "allow to call .foo" do
      expect(service.foo(:foo)).to eq(:foo)
    end
  end

  context "with many arguments" do
    let(:dependency_class) do
      Class.new do
        def call(id, name)
          "#{id}#{name}"
        end
      end
    end

    it "allow to call .foo" do
      expect(service.foo(:foo, :bar)).to eq("foobar")
    end
  end

  context "with many arguments and default value" do
    let(:dependency_class) do
      Class.new do
        def call(id, name = :bar)
          "#{id}#{name}"
        end
      end
    end

    it "allow to call .foo" do
      expect(service.foo(:foo)).to eq("foobar")
    end
  end

  context "with single keyword argument" do
    let(:dependency_class) do
      Class.new do
        def call(id:)
          id
        end
      end
    end

    it "allow to call .foo" do
      expect(service.foo(id: :foo)).to eq(:foo)
    end
  end

  context "with many keyword arguments" do
    let(:dependency_class) do
      Class.new do
        def call(id:, name:)
          "#{id}#{name}"
        end
      end
    end

    it "allow to call .foo" do
      expect(service.foo(id: :foo, name: :bar)).to eq("foobar")
    end
  end

  context "with many keyword arguments and default value" do
    let(:dependency_class) do
      Class.new do
        def call(id:, name: :bar)
          "#{id}#{name}"
        end
      end
    end

    it "allow to call .foo" do
      expect(service.foo(id: :foo)).to eq("foobar")
    end
  end

  context "dependency with context" do
    let(:dependency_class) do
      Class.new do
        include Tardigrade::Dependency

        with :params

        def call
          params
        end
      end
    end

    before do
      @service_class = Class.new do
        include Tardigrade::Injector

        import :foo

        def params
          { arg1: :value1 }
        end
      end
    end

    it "allow to call .foo" do
      expect(service.foo).to eq(arg1: :value1)
    end
  end

  describe ".build_dependency" do
    let(:dependency_class) do
      Class.new do
        include Tardigrade::Dependency

        with :params

        def call
          params
        end
      end
    end

    before do
      @service_class = Class.new do
        include Tardigrade::Injector

        import :foo

        def params
          { arg1: :value1 }
        end
      end
    end

    it "returns dependency object" do
      obj = @service_class.build_dependency(service, dependency_class)
      expect(obj).to be_a(dependency_class)
      expect(obj.params).to eq({ arg1: :value1 })
    end
  end
end
