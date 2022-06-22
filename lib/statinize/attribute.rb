module Statinize
  class Attribute
    include Comparable

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
      statinizer.add_attribute(self) unless attribute_exists?
      klass.send(:attr_accessor, name)
      self
    end

    def <=>(other)
      name == other.name &&
        options == other.options &&
        klass == other.klass
    end

    private

    def statinizer
      klass.statinizer
    end

    def attribute_exists?
      statinizer.attribute_exists?(self)
    end
  end
end
