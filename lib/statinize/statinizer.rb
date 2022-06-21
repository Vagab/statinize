class Statinizer
  attr_reader :attrs, :force

  def initialize(klass, force)
    @klass = klass
    @force = force
    @attrs = Set.new
  end

  def attr_names
    attrs.map(&:name)
  end

  def add_attribute(attribute)
    @attrs.add(attribute)
  end

  def forced_attributes
    attrs.select { |attr| attr.validators.include? :force }
  end
end
