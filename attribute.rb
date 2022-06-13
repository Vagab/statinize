class Attribute
  def initialize(klass, attribute, options)
    @klass = klass
    @attribute = attribute
    @options = options
  end

  def self.create(klass, attribute, options)
    new(klass, attribute, options).create
  end

  def create
    statinizer.add_attribute(attribute)
    statinizer.add_options(attribute => options)
    klass.send(:attr_accessor, attribute)
  end

  private

  attr_reader :klass, :attribute, :options

  def statinizer
    klass.statinizer
  end
end
