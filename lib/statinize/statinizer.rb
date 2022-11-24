module Statinize
  class Statinizer
    include DSL

    attr_reader :klass, :before_callbacks

    def initialize(klass)
      @klass = klass
      @force = config.force
      @before_callbacks = []
    end

    def config
      @config ||= Config
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

    def run_before_callbacks(instance)
      before_callbacks.each do |callback|
        instance.instance_exec(&callback) if callback.is_a? Proc
      end
    end

    def attribute?(attribute)
      attributes.map(&:name).include? attribute.name
    end

    def check_validators_exist!
      raise NoSuchValidatorError unless all_validators_defined?
    end

    def merge_options(**options)
      attributes.each do |attribute|
        attribute.options_collection.each do |option|
          option.merge!(options)
        end
      end
    end

    def populate(attrs)
      attrs.each do |attr|
        attribute attr.arg_name, name: attr.name, default: attr.default, default_exec: attr.default_exec
        attributes.find { _1.name == attr.name }.tap do |attr_to_populate|
          attr_to_populate.options_collection = attr.options_collection.clone
          attr_to_populate.options = attr.options.clone
        end
      end
    end

    protected

    def all_validators_defined?
      attributes.map { |attr| attr.options_collection.all_validators_defined? }.all? { !!_1 }
    end
  end
end
