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
      attributes.add(attribute) unless attribute? attribute
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

    protected

    def all_validators_defined?
      attributes.map { |attr| attr.options.all_validators_defined? }.all? { !!_1 }
    end
  end
end
