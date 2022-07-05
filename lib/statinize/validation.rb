module Statinize
  class Validation
    INSTANCE_METHODS = %i[validate validate! valid? invalid? errors]

    attr_reader :statinizer, :instance

    def initialize(statinizer, instance)
      @statinizer = statinizer
      @instance = instance

      define_instance_methods
    end

    def validate
      @errors = Errors.new
      @erroneous_attributes = Set.new

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
      attributes.each do |attr|
        next unless attr.options.should_validate?(instance)

        attr_value = instance.public_send(attr.name)

        attr.options.validators.each do |validator_class, validator_value|
          validator_instance = validator_class.new(attr_value, validator_value)

          next if validator_instance.valid?
          next if validator_class == TypeValidator && cast(attr)

          erroneous_attributes.add(attr)
          @errors << { attr.name => validator_instance.error }
        end
      end
    end

    def cast(attr)
      caster = Caster.new(instance, attr)

      attr.options.should_cast? && caster.cast
    end

    def should_raise?
      return false if valid?

      statinizer.force? ||
        erroneous_attributes.intersect?(attributes.select { |a| a.options.should_force? })
    end

    def erroneous_attributes
      @erroneous_attributes ||= Set.new
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
  end
end
