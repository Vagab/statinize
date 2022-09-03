RSpec.describe "Initialize with hash" do
  context "symbol keys" do
    let(:params) { { name: "name", age: 69 } }
    subject { InitializeWithHash::Example.new(params) }

    it "does not raise an error" do
      expect { subject }.to_not raise_error
    end

    it "assigns name" do
      expect(subject.name).to eq params[:name]
    end

    it "assigns age" do
      expect(subject.age).to eq params[:age]
    end
  end

  context "string keys" do
    let(:params) { { "name" => "name", "age" => 69 } }
    subject { InitializeWithHash::Example.new(params) }

    it "does not raise an error" do
      expect { subject }.to_not raise_error
    end

    it "assigns name" do
      expect(subject.name).to eq params["name"]
    end

    it "assigns age" do
      expect(subject.age).to eq params["age"]
    end
  end
end

module InitializeWithHash
  class Example
    include Statinize::Statinizable

    statinize do
      attribute :name, :age
    end
  end
end
