class Attribute
  attr_reader :klass, :name, :options, :validators

  def initialize(klass, name, options)
    @klass = klass
    @name = name
    @options = options
    @validators = options.keys
  end

  def self.create(klass, name, options)
    new(klass, name, options).create
  end

  def create
    statinizer.add_attribute(self)
    klass.send(:attr_accessor, name)
  end

  private

  def statinizer
    klass.statinizer
  end
end
