module Statinize
  class Attribute
    include Comparable

    attr_reader :klass, :name, :options

    def initialize(klass, name, options)
      @klass = klass
      @name = name
      @options = options
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

    def should_cast?
      options.keys.include?(:type) && options.keys.include?(:cast)
    end

    def should_force?
      options.keys.include? :force
    end

    def validators
      @validators ||= existing_validators
        .transform_keys { |k| Object.const_get("Statinize::#{k}Validator") }
    end

    private

    def actual_validators
      options_dup = options.dup

      options_dup
        .reject { |k, _| Validator::NOT_VALIDATORS.include? k }
        .transform_keys { |validator| validator.to_s.capitalize }
    end

    def existing_validators
      actual_validators
        .select { |k, _| Object.const_defined? "Statinize::#{k}Validator" }
    end

    def all_validators_exist?
      actual_validators
        .all? { |k, _| Object.const_defined? "Statinize::#{k}Validator" }
    end

    def statinizer
      klass.statinizer
    end

    def attribute?
      statinizer.attribute?(self)
    end
  end
end
