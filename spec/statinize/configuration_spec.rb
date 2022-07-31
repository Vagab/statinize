RSpec.describe "Configuration" do
  subject(:example) { ConfigurationSpec::Example.new }

  describe "force" do
    it "forces all classes" do
      expect { example }.to raise_error(Statinize::ValidationError)
    end
  end
end

Statinize::Statinizer.configure do |config|
  config.force = true
end

module ConfigurationSpec
  class Example
    include Statinize::Statinizable

    statinize do
      attribute :name, type: String, presence: true
    end
  end
end

Statinize::Statinizer.configure do |config|
  config.force = nil
end
