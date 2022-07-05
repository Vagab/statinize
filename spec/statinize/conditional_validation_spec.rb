RSpec.describe "Conditional Validation" do
  describe "#if condition" do
    context "lambda" do
      subject { ConditionalValidation::ExampleClass.new(age: 6, entity: "1") }

      it { is_expected.to be_valid }
    end
  end
end

module ConditionalValidation
  class ExampleClass
    include Statinize::Statinizable

    statinize do
      attribute :entity, :name, :age
      validate :entity, type: String, presence: true, if: -> { age == 6 }
    end
  end
end
