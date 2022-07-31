RSpec.describe "Casting" do
  subject(:example) { Casting::Example }

  describe "casting" do
    context "when type is integer" do
      subject { example.new }

      it "casts to integer" do
        expect(subject.age).to eq 0
      end
    end

    context "when type is string" do
      subject { example.new }

      it "casts to string" do
        expect(subject.name).to eq ""
      end
    end

    context "when type is float" do
      subject { example.new }

      it "casts to float" do
        expect(subject.price).to eq 0.0
      end
    end

    context "when type is complex" do
      subject { example.new }

      it "casts to integer" do
        expect(subject.coord).to eq nil.to_c
      end
    end

    context "when type is rational" do
      subject { example.new }

      it "casts to integer" do
        expect(subject.portion).to eq nil.to_r
      end
    end

    context "when type is symbol" do
      subject { example.new(status: "occupied") }

      it "casts to symbol" do
        expect(subject.status).to eq :occupied
      end
    end

    context "when type is proc" do
      subject { example.new(action: :new?) }

      it "casts to proc" do
        expect(subject.action).to eq :new?.to_proc
      end
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
      end
    end
  end
end
