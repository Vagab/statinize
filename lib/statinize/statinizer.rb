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

    def validate(*attrs, **options)
      attrs.each do |attr|
        attribute = attributes.find { _1.name == attr }
        attribute.options.merge!(options)
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
      attributes.add(attribute)
    end

    def attributes
      @attributes ||= Set.new
    end

    def attribute?(attribute)
      attributes.include? attribute
    end

    def check_validators_exist!
      raise NoSuchValidatorError unless all_validators_exist?
    end

    private

    def all_validators_exist?
      attributes.map { |attr| attr.options.all_validators_defined? }.all? { !!_1 }
    end
  end
end
