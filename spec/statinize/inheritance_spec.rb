RSpec.describe "Inheritance" do
  context "child with attribute" do
    subject { Inheritance::ChildWithAttribute.new(params) }

    context "wrong parameters" do
      let!(:params) { { a: 1, b: 2, c: 1 } }

      it { should_not be_valid }
    end

    context "correct parameters" do
      let!(:params) { { a: 1, b: "1", c: 1 } }

      it { should be_valid }
    end
  end

  context "child without attribute" do
    subject { Inheritance::ChildWithoutAttribute.new(params) }

    context "wrong parameters" do
      let!(:params) { { a: 1, b: "1" } }

      it { should_not be_valid }
    end

    context "correct parameters" do
      let!(:params) { { a: 1, b: 1 } }

      it { should be_valid }
    end
  end

  context "inheritance with missing attributes" do
    subject { Inheritance::NakedChild.new(params) }
    let!(:params) { { a: 1, b: 1 } }

    it { should be_valid }
  end
end

module Inheritance
  class Parent
    include Statinize::Statinizable

    statinize do
      attribute :a, :b, type: Integer
    end
  end

  class NakedParent; include Statinize::Statinizable; end

  class ChildWithAttribute < Parent
    statinize do
      attribute :b, type: String
      attribute :c, type: Integer
    end
  end

  class ChildWithoutAttribute < Parent; end

  class NakedChild < NakedParent
    statinize do
      attribute :a, :b
    end
  end
end
