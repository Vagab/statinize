RSpec.describe Statinize do
  describe "statinizer" do
    subject { ExampleClass.statinizer }

    its(:class) { should eq Statinize::Statinizer }

    context "when forced statinizer" do
      subject { ExampleForcedClass.statinizer }

      its(:force) { should be_truthy }
    end
  end

  describe "attributes" do
    subject { ExampleClass.statinizer.attributes }

    its_map(:class) { are_expected.to all eq Statinize::Attribute }
    its(:count) { should eq 3 }
  end

  describe "statinization" do
    subject { ExampleClass.new(first_name: "a", last_name: "b", age: 1) }

    its_block { is_expected.to_not raise_error }
    it { should be_valid }

    context "when invalid attributes" do
      subject { ExampleClass.new(first_name: "a", last_name: "b", age: {}) }

      its_block { is_expected.to_not raise_error }
      it { should_not be_valid }

      context "when casted attribute" do
        subject { ExampleClass.new(first_name: "a", last_name: "b", age: "1") }

        its_block { is_expected.to_not raise_error }
        it { should be_valid }
      end

      context "when invalid forced attribute" do
        subject { ExampleClass.new(first_name: 1, last_name: 2, age: 1) }

        its_block do
          is_expected.to raise_error(
            Statinize::ValidationError,
            /Validation(.*?)First(.*?)Str(.*?)Int(.*?)Last(.*?)Str(.*?)Int/,
          )
        end
      end

      context "when forced class" do
        subject { ExampleForcedClass.new(first_name: {}, last_name: 2, age: "1") }

        its_block do
          is_expected.to raise_error(
            Statinize::ValidationError,
            /Validation(.*?)First(.*?)Str(.*?)Hash(.*?)Last(.*?)Str(.*?)Int(.*?)Age(.*?)Int(.*?)Str/,
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
    attribute :first_name, :last_name
    attribute :age

    validate :first_name, :last_name, type: String
    validate :age, type: Integer, presence: true
  end
end

Statinize::Statinizer.configure do |config|
  config.force = nil
end
