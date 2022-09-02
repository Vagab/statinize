RSpec.describe "Validation" do
  subject(:example) { ValidationSpec::Example.new }

  describe "validation" do
    it { is_expected.to_not be_valid }

    it "returns correct errors" do
      expect(example.errors).to eq({
        name: ["should be one of cool, not_cool, awesome", "is blank"],
      })
    end

    context "when forced" do
      subject(:example) { ValidationSpec::ForcedExample.new }

      it "raises an error with proper error message" do
        expect { subject }.to raise_error(
          Statinize::ValidationError,
          "ValidationError: " \
            "Name should be one of cool, not_cool, awesome; " \
            "Name is blank; " \
            "Age is blank"
        )
      end
    end
  end
end

module ValidationSpec
  class Example
    include Statinize::Statinizable

    statinize do
      attribute :name, type: String, inclusion: ["cool", "not_cool", "awesome"], presence: true
    end
  end

  class ForcedExample
    include Statinize::Statinizable

    statinize do
      force true
      attribute :name, type: String, inclusion: ["cool", "not_cool", "awesome"], presence: true
      attribute :age, presence: true
    end
  end
end
