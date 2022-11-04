RSpec.describe "Configuration" do
  subject(:example) { ConfigurationSpec::Example.new }

  describe "force" do
    its_block { is_expected.to raise_error(Statinize::ValidationError) }
  end
end

Statinize::Statinizer.configure do |config|
  config.force = true
end

module ConfigurationSpec
  class Example
    include Statinize

    statinize do
      attribute :name, type: String, presence: true
    end
  end
end

Statinize::Statinizer.configure do |config|
  config.force = nil
end
