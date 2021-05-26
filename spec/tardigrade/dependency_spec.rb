RSpec.describe Tardigrade::Dependency do
  describe ".with" do
    it "allows to pass list of context names" do
      expect {
        Class.new do
          include Tardigrade::Dependency

          with :foo
        end
      }.not_to raise_error
    end

    it "saves data in argument_names instance" do
      klass = Class.new do
        include Tardigrade::Dependency

        with :foo, :bar
      end

      values = klass.instance_variable_get(:@argument_names)
      expect(values).to match_array(%i(foo bar))
    end
  end

  describe ".argument_names" do
    it "returns empty Array by default" do
      klass = Class.new do
        include Tardigrade::Dependency
      end

      expect(klass.argument_names).to eq([])
    end

    it "returns required arguments" do
      klass = Class.new do
        include Tardigrade::Dependency

        with :foo, :bar
      end

      expect(klass.argument_names).to match_array(%i(foo bar))
    end
  end

  it "allows to build object with arguments" do
    klass = Class.new do
      include Tardigrade::Dependency

      with :foo, :bar
    end

    expect {
      klass.new(foo: :foo, bar: :bar)
    }.not_to raise_error
  end

  it "raises error when required argument missing" do
    klass = Class.new do
      include Tardigrade::Dependency

      with :foo, :bar
    end

    expect {
      klass.new(foo: :foo)
    }.to raise_error(ArgumentError).with_message("Argument :bar missing")
  end

  it "accesses to context method" do
    klass = Class.new do
      include Tardigrade::Dependency

      with :foo
    end

    object = klass.new(foo: :foo)
    expect(object.private_methods).to include(:foo)
    expect(object.send(:foo)).to eq(:foo)
  end
end
