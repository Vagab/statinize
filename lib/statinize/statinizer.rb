module Statinize
  class Statinizer
    attr_reader :attrs, :klass

    def self.configure(&block)
      Statinize::Configuration.configure(&block)
    end

    def initialize(klass)
      @klass = klass
      @attrs = Set.new
      @force = config.force
    end

    def config
      @config ||= Statinize::Configuration.instance
    end

    def force(force = nil)
      force.nil? ? @force : @force = force
    end

    def attribute(*attrs, **options)
      attrs.each do |attr|
        Attribute.create(klass, attr, options)
      end
    end

    def add_attribute(attribute)
      @attrs.add(attribute)
    end

    def forced_attributes
      attrs.select { |attr| attr.validators.include? :force }
    end

    def casted_attributes
      attrs.select { |attr| attr.validators.include? :cast }
    end

    def attribute_exists?(attribute)
      attrs.include? attribute
    end
  end
end
