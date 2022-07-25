module Statinize
  class Statinizer
    attr_reader :klass

    def initialize(klass)
      @klass = klass
      @force = config.force
    end

    def attribute(*attrs, **options)
      attrs.each do |attr|
        Attribute.create(klass, attr, options) unless attribute? attr
      end
    end

    def validate(*attrs, **options)
      attrs.each do |attr|
        attribute = attributes.find { _1.name == attr }
        attribute = Attribute.create(klass, attr) unless attribute
        attribute.add_options(options)
      end
    end

    def with(**options, &block)
      instance = self.class.new(klass)
      instance.force(force)

      klass.instance_variable_set(:@statinizer, instance)
      instance.instance_exec(&block)
      klass.instance_variable_set(:@statinizer, self)

      instance.merge_options!(**options)

      populate!(instance.attributes)
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
      attributes.add?(attribute)
    end

    def attributes
      @attributes ||= Set.new
    end

    def attribute?(attribute)
      attributes.map(&:name).include? attribute.name
    end

    def check_validators_exist!
      raise NoSuchValidatorError unless all_validators_defined?
    end

    private

    def merge_options!(**options)
      attributes.each do |attribute|
        attribute.add_options(options)
      end
    end

    def populate!(attrs)
      attrs.each do |attr|
        attribute attr.name
        attributes
          .find { _1.name == attr.name }
          .options = attr.options.clone
      end
    end

    def all_validators_defined?
      attributes.map { |attr| attr.options.all_validators_defined? }.all? { !!_1 }
    end
  end
end
