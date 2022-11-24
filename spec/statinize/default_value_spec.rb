RSpec.describe "Default value" do
  context "when correct default types" do
    subject { DefaultValue::Example.new(params) }

    context "when empty params" do
      let!(:params) { {} }

      it { should be_valid }
      its(:a) { should eq "a" }
      its(:b) { should eq 2 }
    end

    context "when params present" do
      let!(:params) { { a: "b", b: 3 } }

      it { should be_valid }
      its(:a) { should eq "b" }
      its(:b) { should eq 3 }

      context "when proc type" do
        it { should be_valid }
      end

      context "when collection default" do
        let!(:params) { {} }

        context "when adding to the same instance" do
          before do
            subject.c << 5
          end

          its(:c) { should eq([5]) }
        end

        context "when same instance's default was modified" do
          before do
            subject.c << 5
          end

          it "assigns correct default" do
            expect(DefaultValue::Example.new.c).to be_empty
          end
        end

        context "when another instance's default was modified" do
          before do
            DefaultValue::Example.new.c << 5
          end

          its(:c) { should be_empty }
        end
      end
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
      attribute :c, type: Array, default: []
      attribute :d, type: Proc, default: proc { "69" }
    end
  end

  class ExampleWithWrongType
    include Statinize

    statinize do
      attribute :a, type: String, default: 1
    end
  end
end
