RSpec.describe "Conditional Validation" do
  let!(:example) { ConditionalValidationSpec::Example }

  describe "conditions" do
    context "when two conditions for same attribute and one is forced" do
      context "when forced condition is true" do
        context "attribute is valid" do
          subject { example.new(age: 6, entity: "a") }

          it { is_expected.to be_valid }
        end

        context "attribute is invalid" do
          subject { example.new(age: 6, entity: :a) }

          it "raises an error" do
            expect { subject }.to raise_error(
              Statinize::ValidationError,
              "ValidationError: Entity should be String, found Symbol instead",
            )
          end
        end
      end

      context "when second condition is true" do
        context "attribute is valid" do
          subject { example.new(age: 9, entity: :a) }

          it { is_expected.to be_valid }
        end

        context "attribute is invalid" do
          subject { example.new(age: 9, entity: "1") }

          it { is_expected.to_not be_valid }
          it { expect { subject }.to_not raise_error }
        end
      end
    end

    context "when symbol" do
      subject { example.new(age: 42) }

      it { is_expected.to_not be_valid }
      it "has a proper error message" do
        expect(subject.errors).to eq({
          name: ["should be one of hehe"],
        })
      end
    end

    context "when proc" do
      subject { example.new(age: 69) }

      it { is_expected.to_not be_valid }
      it "has a proper error message" do
        expect(subject.errors).to eq({
          name: ["should be one of hoho"],
        })
      end
    end

    context "when if and unless" do
      context "not all if's pass, unless doesn't" do
        subject { example.new(age: 11) }

        it { is_expected.to be_valid }
      end

      context "all if's pass, unless does to" do
        subject { example.new(age: 13, entity: :a) }

        it { is_expected.to be_valid }
      end

      context "all if's pass, unless doesn't" do
        subject { example.new(age: 11, entity: :a) }

        it { is_expected.to_not be_valid }
        it "has a proper error message" do
          expect(subject.errors).to eq({
            name: ["should be one of haha"],
          })
        end
      end
    end
  end
end

module ConditionalValidationSpec
  class Example
    include Statinize::Statinizable

    statinize do
      force false
      attribute :entity, :name, :age
      validate :entity, type: String, presence: true, if: -> { age == 6 }, force: true
      validate :entity, type: Symbol, presence: true, if: proc { |a| a.age == 9 }
      validate :name, inclusion: ["hehe"], if: :is_42?
      validate :name, inclusion: ["hoho"], if: proc { |a| a.age == 69 }
      validate :name, inclusion: ["haha"], if: [-> { age > 10 }, :symbolized?], unless: -> { age > 12 }
    end

    def is_42?
      age == 42
    end

    def symbolized?
      entity.is_a? Symbol
    end
  end
end
