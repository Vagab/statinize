RSpec.describe Statinize do
  describe "statinizer" do
    let!(:statinizer) { ExampleClass.statinizer }

    it "assigns statinizer" do
      expect(statinizer.class).to eq Statinize::Statinizer
    end

    context "when forced statinizer" do
      let!(:statinizer) { ExampleForcedClass.statinizer }

      it "assigns force attribute" do
        expect(statinizer.force).to be_truthy
      end
    end
  end

  describe "attributes" do
    let!(:attributes) { ExampleClass.statinizer.attrs }

    it "assigns attributes to statinizer" do
      expect(attributes.map(&:class).uniq.first).to eq Statinize::Attribute
    end

    it "assigns correct number of attributes" do
      expect(attributes.count).to eq 3
    end
  end

  describe "statinization" do
    subject { ExampleClass.new(first_name: "a", last_name: "b", age: 1) }

    it { expect { subject }.to_not raise_error }
    it { is_expected.to be_valid }

    context "when invalid attributes" do
      subject { ExampleClass.new(first_name: "a", last_name: "b", age: {}) }

      it { expect { subject }.to_not raise_error }
      it { is_expected.to_not be_valid }

      context "when casted attribute" do
        subject { ExampleClass.new(first_name: "a", last_name: "b", age: "1") }

        it { expect { subject }.to_not raise_error }
        it { is_expected.to be_valid }
      end

      context "when invalid forced attribute" do
        subject { ExampleClass.new(first_name: 1, last_name: 2, age: 1) }

        it "raises an error with proper message" do
          expect { subject }.to raise_error(
            Statinize::ValidationError,
            "ValidationError: " \
              "First name should be String, found Integer instead; " \
              "Last name should be String, found Integer instead"
          )
        end
      end

      context "when forced class" do
        subject { ExampleForcedClass.new(first_name: {}, last_name: 2, age: "1") }

        it "raises an error with proper message" do
          expect { subject }.to raise_error(
            Statinize::ValidationError,
            "ValidationError: " \
              "First name should be String, found Hash instead; " \
              "Last name should be String, found Integer instead; " \
              "Age should be Integer, found String instead"
          )
        end
      end
    end
  end
end

Statinize::Statinizer.configure do |config|
  config.force = true
end

class ExampleClass
  include Statinize::Statinizable

  statinize do
    force false
    attribute :first_name, :last_name, type: String, force: true
    attribute :age, type: Integer, presence: true, cast: true
  end
end

class ExampleForcedClass
  include Statinize::Statinizable

  statinize do
    attribute :first_name, :last_name, type: String
    attribute :age, type: Integer, presence: true
  end
end
