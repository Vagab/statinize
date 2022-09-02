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
      @errors = Errors.new { |h, k| h[k] = [] }
      @erroneous_attributes = Hash.new { |h, k| h[k] = Set.new }
      @erroneous_forced_attributes = Hash.new { |h, k| h[k] = Set.new }

      fill_errors
    end

    def validate!
      validate

      raise ValidationError, errors.nice if should_raise?
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

            if option[:type] && option.should_cast? && attr_value.nil? && (option[:presence] || option[:nil] == false)
              cast(attr, option)
            end

            next if validator_instance.valid?
            next if validator_class == TypeValidator && cast?(attr, option)

            force = option[:force] ||
              (statinizer.force? && option[:force].nil?)

            erroneous_attributes[attr.name].add? option

            unless @errors[attr.name].include?(validator_instance.error)
              @errors[attr.name] << validator_instance.error
            end

            erroneous_forced_attributes[attr.name].add option if force
          end
        end
      end
    end

    def cast?(attr, option)
      option.should_cast? && cast(attr, option)
    end

    def cast(attr, option)
      caster(attr, option).cast
    end

    def caster(attr, option)
      Caster.new(instance, attr, option)
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
