module Statinize
  class Statinizer
    attr_reader :klass

    def initialize(klass)
      @klass = klass
      @force = config.force
    end

    def attribute(*attrs, **options)
      attrs.each do |attr|
        Attribute.create(klass, attr, options)
      end
    end

    def force(force = nil)
      force.nil? ? @force : @force = force
    end

    def self.configure(&block)
      Configuration.configure(&block)
    end

    def config
      @config ||= Configuration.instance
    end

    def force?
      @force
    end

    def add_attribute(attribute)
      attrs.add(attribute)
    end

    def attribute_exists?(attribute)
      attrs.include? attribute
    end

    def attrs
      @attrs ||= Set.new
    end
  end
end
