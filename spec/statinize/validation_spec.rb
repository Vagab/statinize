RSpec.describe "Validation" do
  subject(:example) { ValidationSpec::Example.new }

  describe "validation" do
    it { should_not be_valid }
    its(:errors) { should match({ name: [/one of cool, not_cool, awesome/, /blank/] }) }

    context "when forced" do
      subject(:example) { ValidationSpec::ForcedExample.new }

      its_block { is_expected.to raise_error(Statinize::ValidationError, /Validation(.*?)Name(.*?)Name(.*?)Age/) }
    end
  end
end

module ValidationSpec
  class Example
    include Statinize

    statinize do
      attribute :name, type: String, inclusion: ["cool", "not_cool", "awesome"], presence: true
    end
  end

  class ForcedExample
    include Statinize

    statinize do
      force true
      attribute :name, type: String, inclusion: ["cool", "not_cool", "awesome"], presence: true
      attribute :age, presence: true
    end
  end
end
