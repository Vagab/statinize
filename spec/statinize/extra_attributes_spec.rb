RSpec.describe "Extra Attributes" do
  subject { ExtraAttributes::Example.new(params) }

  context "not too many params" do
    let!(:params) { { a: 1 } }

    it { is_expected.to be_valid }
  end

  context "too many params" do
    let!(:params) { { a: 1, b: 2 } }

    it "raises an error" do
      expect { subject }.to raise_error(Statinize::UnknownAttributeError, "Attributes b are unknown")
    end
  end
end

module ExtraAttributes
  class Example
    include Statinize::Statinizable

    statinize do
      attribute :a
    end
  end
end
