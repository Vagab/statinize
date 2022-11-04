RSpec.describe "Extra Attributes" do
  subject { ExtraAttributes::Example.new(params) }

  context "not too many params" do
    let!(:params) { { a: 1 } }

    it { should be_valid }
  end

  context "too many params" do
    let!(:params) { { a: 1, b: 2 } }

    its_block { is_expected.to_not raise_error }
  end
end

module ExtraAttributes
  class Example
    include Statinize

    statinize do
      attribute :a
    end
  end
end
