module Statinize
  class Statinizer
    include DSL

    attr_reader :klass, :before_callbacks

    def self.configure(&block)
      Configuration.configure(&block)
    end

    def initialize(klass)
      @klass = klass
      @force = config.force
      @before_callbacks = []
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

    def run_before_callbacks(instance)
      before_callbacks.each do |callback|
        instance.instance_exec(&callback) if callback.is_a? Proc

        next unless callback.is_a? Array

        instance.instance_variable_set(
          "@#{callback[0]}",
          callback[1].call(instance.instance_variable_get("@#{callback[0]}"))
        )
      end
    end

    def attribute?(attribute)
      attributes.map(&:name).include? attribute.name
    end

    def check_validators_exist!
      raise NoSuchValidatorError unless all_validators_defined?
    end

    protected

    def merge_options(**options)
      attributes.each do |attribute|
        attribute.add_options(options)
      end
    end

    def populate(attrs)
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
