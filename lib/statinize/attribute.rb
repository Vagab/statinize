module Statinize
  class Attribute
    include Comparable

    attr_reader :klass, :name, :options

    def initialize(klass, name, options)
      @klass = klass
      @name = name
      @options = Attribute::Options.new.merge(options)
    end

    def self.create(klass, name, options)
      new(klass, name, options).create
    end

    def create
      statinizer.add_attribute(self) unless attribute?
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

    def attribute?
      statinizer.attribute?(self)
    end
  end
end
