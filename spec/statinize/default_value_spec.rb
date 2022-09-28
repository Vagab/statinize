RSpec.describe "Default value" do
  context "correct default types" do
    context "empty params" do
      subject { DefaultValue::Example.new(params) }

      let!(:params) { {} }

      it { is_expected.to be_valid }
      its(:a) { is_expected.to eq "a" }
      its(:b) { is_expected.to eq 2 }
    end
  end
end

module DefaultValue
  class Example
    include Statinize::Statinizable

    statinize do
      attribute :a, type: String, default: "a"
      attribute :b, type: Integer, default: 2
    end
  end

  class ExampleWithWrongType
    include Statinize::Statinizable

    statinize do
      attribute :a, type: String, default: 1
    end
  end
end
