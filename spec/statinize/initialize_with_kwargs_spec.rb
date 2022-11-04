RSpec.describe "Initialize with kwargs" do
  subject { InitializeWithHash::Example.new(name: "name", age: 69) }

  its_block { is_expected.to_not raise_error }
  its(:name) { should eq "name" }
  its(:age) { should eq 69 }
end

module InitializeWithKwargs
  class Example
    include Statinize

    statinize do
      attribute :name, :age
    end
  end
end
