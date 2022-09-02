RSpec.describe "Initialize with kwargs" do
  subject { InitializeWithHash::Example.new(name: "name", age: 69) }

  it "does not raise an error" do
    expect { subject }.to_not raise_error
  end

  it "assigns name" do
    expect(subject.name).to eq "name"
  end

  it "assigns age" do
    expect(subject.age).to eq 69
  end
end

module InitializeWithKwargs
  class Example
    include Statinize::Statinizable

    statinize do
      attribute :name, :age
    end
  end
end
