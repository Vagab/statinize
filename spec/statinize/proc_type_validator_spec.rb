RSpec.describe "Proc type validation" do
  context "when expected a string" do
    subject { ProcTypeValidatorDummyStringChild.new(params) }

    context "when attribute is a string" do
      let!(:params) { { a: "a" } }

      its(:valid?) { should be_truthy }
    end

    context "when attribute is not a string" do
      let!(:params) { { a: 1 } }

      its(:valid?) { should be_falsey }
    end
  end

  context "when expected an integer" do
    subject { ProcTypeValidatorDummyIntegerChild.new(params) }

    context "when attribute is an integer" do
      let!(:params) { { a: 1 } }

      its(:valid?) { should be_truthy }
    end

    context "when attribute is not an integer" do
      let!(:params) { { a: "a" } }

      its(:valid?) { should be_falsey }
    end
  end
end

class ProcTypeValidatorDummyParent
  include Statinize

  statinize do
    attribute :a, type: -> { type }
  end
end

class ProcTypeValidatorDummyStringChild < ProcTypeValidatorDummyParent
  def type = String
end

class ProcTypeValidatorDummyIntegerChild < ProcTypeValidatorDummyParent
  def type = Integer
end
