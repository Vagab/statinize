RSpec.describe "Named attribute" do
  context "named attribute" do
    subject { NamedAttribute::Example.new(params) }

    let!(:params) do
      {
        name: "my_name", my_name: "name",
        stuff: "stuff", also_stuff: "also_stuff",
      }
    end

    its(:my_name) { should eq "my_name" }
    its(:name) { should eq "name" }
    its(:stuff) { should eq "stuff" }
    its(:also_stuff) { should eq "also_stuff" }
  end
end

module NamedAttribute
  class Example
    include Statinize

    statinize do
      attribute :name, name: :my_name
      attribute :my_name, name: :name
      attribute :stuff, name: :stuff
      attribute :also_stuff
    end
  end
end
