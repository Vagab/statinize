RSpec.describe "Casting" do
  subject(:example) { Casting::Example }

  describe "casting" do
    context "when type is integer" do
      subject { example.new }

      it "casts to integer" do
        expect(subject.age).to eq 0
      end
      its(:age) { should eq 0 }
    end

    context "when type is string" do
      subject { example.new }

      its(:name) { should eq "" }
    end

    context "when type is float" do
      subject { example.new }

      its(:price) { should eq 0.0 }
    end

    context "when type is complex" do
      subject { example.new }

      its(:coord) { should eq nil.to_c }
    end

    context "when type is rational" do
      subject { example.new }

      its(:portion) { should eq nil.to_r }
    end

    context "when type is symbol" do
      subject { example.new(status: "occupied") }

      its(:status) { should eq :occupied }
    end

    context "when type is proc" do
      subject { example.new(action: :new?) }

      its(:action) { should eq :new?.to_proc }
    end

    context "when type is bigdecimal" do
      subject { example.new(percentage: 1.0 / 3) }

      its(:percentage) { should eq (1.0 / 3).to_d }
    end
  end
end

module Casting
  class Example
    include Statinize::Statinizable

    statinize do
      with cast: true, nil: false do
        attribute :age, type: Integer
        attribute :name, type: String
        attribute :price, type: Float
        attribute :coord, type: Complex
        attribute :portion, type: Rational
        attribute :status, type: Symbol
        attribute :enum, type: Enumerator
        attribute :action, type: Proc
        attribute :percentage, type: BigDecimal
      end
    end
  end
end
