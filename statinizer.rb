class Statinizer
  attr_reader :attrs, :options, :force

  def initialize(klass, force)
    @klass = klass
    @force = force
    @attrs = Set.new
    @options = {}
  end

  def add_attribute(attribute)
    @attrs.add(attribute)
  end

  def add_options(options)
    @options.merge!(options)
  end
end
