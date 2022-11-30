RSpec.describe "With" do
  subject { WithDummy.new(params) }

  context "two with blocks" do
    context "first validation is violated" do
      let!(:params) { { a: "a", c: :a } }

      its(:valid?) { should be_truthy }

      context "both validations are calls to validate" do
        let!(:params) { { a: :a, c: "c" } }

        its(:valid?) { should be_falsey }
      end
    end
  end
end

class WithDummy
  include Statinize

  statinize do
    with type: Symbol do
      attribute :a
    end

    with presence: true do
      attribute :a
    end

    attribute :c
    with type: Symbol do
      validate :c
    end

    with presence: true do
      validate :c
    end
  end
end
