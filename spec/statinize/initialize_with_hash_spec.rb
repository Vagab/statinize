RSpec.describe "Initialize with hash" do
  context "symbol keys" do
    let(:params) { { name: "name", age: 69 } }
    subject { InitializeWithHash::Example.new(params) }

    its_block { is_expected.to_not raise_error }
    its(:name) { should eq params[:name] }
    its(:age) { should eq params[:age] }
  end

  context "string keys" do
    let(:params) { { "name" => "name", "age" => 69 } }
    subject { InitializeWithHash::Example.new(params) }

    its_block { is_expected.to_not raise_error }
    its(:name) { should eq params["name"] }
    its(:age) { should eq params["age"] }
  end
end

module InitializeWithHash
  class Example
    include Statinize

    statinize do
      attribute :name, :age
    end
  end
end
