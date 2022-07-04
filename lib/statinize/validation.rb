module Statinize
  class Validation
    attr_reader :statinizer, :instance

    def initialize(statinizer, instance)
      @statinizer = statinizer
      @instance = instance

      define_instance_methods
    end

    def validate
      @errors = Errors.new
      @erroneous_attrs = Set.new

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

    def errors
      @errors ||= Errors.new
    end

    private

    def fill_errors
      attrs.each do |attr|
        attr_value = instance.public_send(attr.name)

        attr.validators.each do |validator_class, validator_value|
          validator_instance = validator_class.new(attr.name, attr_value, validator_value)

          next if validator_instance.valid?
          next if validator_class == TypeValidator && cast(attr)

          erroneous_attrs.add(attr)
          @errors << validator_instance.error
        end
      end
    end

    def cast(attr)
      caster = Caster.new(instance, attr)

      attr.should_cast? && caster.cast
    end

    def should_raise?
      return true if statinizer.force?

      invalid? &&
        erroneous_attrs.intersect?(attrs.select(&:should_force?))
    end

    def erroneous_attrs
      @erroneous_attrs ||= Set.new
    end

    def attrs
      statinizer.attrs
    end

    def define_instance_methods
      %i[validate! validate valid? invalid? errors].each do |meth|
        instance.class.class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def #{meth}
            validation.#{meth}
          end
        RUBY_EVAL
      end
    end
  end
end
