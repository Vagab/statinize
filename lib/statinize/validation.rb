module Statinize
  class Validation
    INSTANCE_METHODS = %i[validate validate! valid? invalid? errors]

    attr_reader :statinizer, :instance, :errors

    def initialize(statinizer, instance)
      @statinizer = statinizer
      @instance = instance

      define_instance_methods
    end

    def validate
      @errors = Errors.new
      @erroneous_attributes = Hash.new { |h, k| h[k] = [] }
      @erroneous_forced_attributes = Hash.new { |h, k| h[k] = [] }

      fill_errors
    end

    def validate!
      validate

      raise ValidationError, errors.to_s if should_raise?
    end

    def valid?
      errors.empty?
    end

    def invalid?
      !valid?
    end

    private

    def fill_errors
      attributes.each do |attr|
        attr.options.each do |option|
          next unless option.should_validate?(instance)

          attr_value = instance.public_send(attr.name)

          option.validators.each do |validator_class, validator_value|
            validator_instance = validator_class.new(attr_value, validator_value)

            next if validator_instance.valid?
            next if validator_class == TypeValidator && cast(attr, option)

            force = option[:force] ||
              (statinizer.force? && option[:force].nil?)

            erroneous_attributes[attr.name] << option
            erroneous_forced_attributes[attr.name] << option if force
            @errors << { attr.name => validator_instance.error }
          end
        end
      end
    end

    def cast(attr, option)
      caster = Caster.new(instance, attr, option)

      option.should_cast? && caster.cast
    end

    def should_raise?
      return false if valid?

      erroneous_attributes.keys.intersect?(erroneous_forced_attributes.keys)
    end

    def attributes
      statinizer.attributes
    end

    def define_instance_methods
      INSTANCE_METHODS.each do |meth|
        instance.class.class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def #{meth}
            validation.#{meth}
          end
        RUBY_EVAL
      end
    end

    attr_reader :erroneous_attributes, :erroneous_forced_attributes
  end
end
