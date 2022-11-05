RSpec.describe "Named attribute" do
  context "named attribute" do
    subject { NamedAttribute::Example.new(params) }

    let!(:params) do
      {
        name: "my_name", my_name: "name",
        stuff: "stuff", also_stuff: "also_stuff",
        ag: 69,
      }
    end

    its(:my_name) { should eq "my_name" }
    its(:name) { should eq "name" }
    its(:stuff) { should eq "stuff" }
    its(:also_stuff) { should eq "also_stuff" }
    its(:age) { should eq 69 }
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

      with presence: true do
        attribute :ag, name: :age
      end
    end
  end
end
