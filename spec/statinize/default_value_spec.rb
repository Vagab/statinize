RSpec.describe "Default value" do
  context "correct default types" do
    subject { DefaultValue::Example.new(params) }

    context "empty params" do
      let!(:params) { {} }

      it { should be_valid }
      its(:a) { should eq "a" }
      its(:b) { should eq 2 }
    end

    context "params present" do
      let!(:params) { { a: "b", b: 3 } }

      it { should be_valid }
      its(:a) { should eq "b" }
      its(:b) { should eq 3 }
    end
  end

  context "wrong default type" do
    subject { DefaultValue::ExampleWithWrongType.new(params) }

    context "empty params" do
      context "empty params" do
        let!(:params) { {} }

        it { should_not be_valid }
        its(:a) { should eq 1 }
      end

      context "params present" do
        let!(:params) { { a: "b" } }

        it { should be_valid }
        its(:a) { should eq "b" }
      end
    end
  end
end

module DefaultValue
  class Example
    include Statinize

    statinize do
      attribute :a, type: String, default: "a"
      attribute :b, type: Integer, default: 2
    end
  end

  class ExampleWithWrongType
    include Statinize

    statinize do
      attribute :a, type: String, default: 1
    end
  end
end
