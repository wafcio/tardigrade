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
        .to eq(foo: { source: Integer, memoize: false },
               bar: { source: String, memoize: false })
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
        .to eq(foo: { source: Integer, memoize: false },
               bar: { source: String, memoize: false })
    end
  end

  describe "dependencies saved as different data type" do
    context "dependency as lambda" do
      let(:dependency) do
        -> { :foo_response }
      end

      it "returns saved dependecy" do
        Tardigrade.add_dependency(:foo, dependency)

        expect(Tardigrade.dependencies)
          .to eq(foo: { source: dependency, memoize: false })
      end
    end

    context "dependency as Proc" do
      let(:dependency) do
        Proc.new { :foo_response }
      end

      it "returns saved dependecy" do
        Tardigrade.add_dependency(:foo, dependency)

        expect(Tardigrade.dependencies)
          .to eq(foo: { source: dependency, memoize: false })
      end
    end

    context "dependency as class with .call" do
      let(:dependency) do
        Class.new do
          def self.call
            :foo_response
          end
        end
      end

      it "returns saved dependecy" do
        Tardigrade.add_dependency(:foo, dependency)

        expect(Tardigrade.dependencies)
          .to eq(foo: { source: dependency, memoize: false })
      end
    end

    context "dependency as class with #call" do
      let(:dependency) do
        Class.new do
          def call
            :foo_response
          end
        end
      end

      it "returns saved dependecy" do
        Tardigrade.add_dependency(:foo, dependency)

        expect(Tardigrade.dependencies)
          .to eq(foo: { source: dependency, memoize: false })
      end
    end

    context "dependency as module with self.call" do
      let(:dependency) do
        Module.new do
          def self.call
            :foo_response
          end
        end
      end

      it "returns saved dependecy" do
        Tardigrade.add_dependency(:foo, dependency)

        expect(Tardigrade.dependencies)
          .to eq(foo: { source: dependency, memoize: false })
      end
    end
  end
end
