RSpec.describe Tardigrade do
  before do
    Tardigrade.instance_variable_set(:@dependencies, nil)
  end

  describe ".add_dependency" do
    it "allows to pass 2 parameters" do
      expect {
        Tardigrade.add_dependency(:foo, Struct)
      }.not_to raise_error
    end

    it "collects several dependencies" do
      Tardigrade.add_dependency(:foo, Integer)
      Tardigrade.add_dependency(:bar, String)

      expect(Tardigrade.instance_variable_get(:@dependencies))
        .to eq(foo: { class: Integer, memoize: false },
               bar: { class: String, memoize: false })
    end
  end

  describe ".dependencies" do
    it "returns empty Hash by default" do
      expect(Tardigrade.dependencies).to eq({})
    end

    it "returns added dependencies" do
      Tardigrade.add_dependency(:foo, Integer)
      Tardigrade.add_dependency(:bar, String)

      expect(Tardigrade.dependencies)
        .to eq(foo: { class: Integer, memoize: false },
               bar: { class: String, memoize: false })
    end
  end
end
