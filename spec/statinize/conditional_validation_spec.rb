RSpec.describe "Conditional Validation" do
  let!(:example) { ConditionalValidationSpec::Example }

  describe "conditions" do
    context "when two conditions for same attribute and one is forced" do
      context "when forced condition is true" do
        context "attribute is valid" do
          subject { example.new(age: 6, entity: "a") }

          it { should be_valid }
        end

        context "attribute is invalid" do
          subject { example.new(age: 6, entity: :a) }

          its_block { is_expected.to raise_error(Statinize::ValidationError, /Entity(.*?)String(.*?)Symbol instead/) }
        end
      end

      context "when second condition is true" do
        context "attribute is valid" do
          subject { example.new(age: 9, entity: :a) }

          it { should be_valid }
        end

        context "attribute is invalid" do
          subject { example.new(age: 9, entity: "1") }

          it { should_not be_valid }
          its_block { is_expected.to_not raise_error }
        end
      end
    end

    context "when symbol" do
      subject { example.new(age: 42) }

      it { should_not be_valid }
      its(:errors) { should match({ name: [/should(.*?)hehe/] }) }
    end

    context "when proc" do
      subject { example.new(age: 69) }

      it { should_not be_valid }
      its(:errors) { should match({ name: [/should(.*?)hoho/] }) }
    end

    context "when if and unless" do
      context "not all if's pass, unless doesn't" do
        subject { example.new(age: 11) }

        it { should be_valid }
      end

      context "all if's pass, unless does to" do
        subject { example.new(age: 13, entity: :a) }

        it { should be_valid }
      end

      context "all if's pass, unless doesn't" do
        subject { example.new(age: 11, entity: :a) }

        it { should_not be_valid }
        its(:errors) { should match({ name: [/should(.*?)haha/] }) }
      end
    end
  end
end

module ConditionalValidationSpec
  class Example
    include Statinize

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
