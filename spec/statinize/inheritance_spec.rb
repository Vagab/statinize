RSpec.describe "Inheritance" do
  context "child with attribute" do
    subject { Inheritance::ChildWithAttribute.new(params) }

    context "wrong parameters" do
      let!(:params) { { a: 1, b: 2, c: 1 } }

      it { is_expected.not_to be_valid }
    end

    context "correct parameters" do
      let!(:params) { { a: 1, b: "1", c: 1 } }

      it { is_expected.to be_valid }
    end
  end

  context "child without attribute" do
    subject { Inheritance::ChildWithoutAttribute.new(params) }

    context "wrong parameters" do
      let!(:params) { { a: 1, b: "1" } }

      it { is_expected.not_to be_valid }
    end

    context "correct parameters" do
      let!(:params) { { a: 1, b: 1 } }

      it { is_expected.to be_valid }
    end
  end
end

module Inheritance
  class Parent
    include Statinize::Statinizable

    statinize do
      attribute :a, :b, type: Integer
    end
  end

  class ChildWithAttribute < Parent
    statinize do
      attribute :b, type: String
      attribute :c, type: Integer
    end
  end

  class ChildWithoutAttribute < Parent; end
end
