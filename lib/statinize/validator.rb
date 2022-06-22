module Statinize
  class Validator
    NOT_VALIDATORS = %i[force cast].freeze

    def initialize(instance)
      @instance = instance

      raise NotStatinizableError unless instance&.class&.statinizer.is_a?(Statinizer)
      raise NoSuchValidatorError unless validators_exist?

      @errors = Errors.new
      @erroneous_attrs = Set.new
    end

    def valid?
      validate
      return false unless errors.empty?

      true
    end

    def invalid?
      !valid?
    end

    def validate
      attrs.each do |attr|
        attr.options.each do |validator, validator_value|
          next if NOT_VALIDATORS.include? validator

          attr_name = attr.name

          validator_class = Object.const_get("Statinize::#{validator.to_s.capitalize}Validator")

          validator_instance = validator_class.new(instance)

          validator_class.public_send(
            :attr_accessor,
            *%i[attr_name attr_value validator_value]
          )

          attr_value = instance.public_send attr_name

          validator_instance.instance_variable_set('@attr_name', attr_name)
          validator_instance.instance_variable_set('@attr_value', attr_value)
          validator_instance.instance_variable_set('@validator_value', validator_value)

          next if validator_instance.valid?
          next if should_cast?(validator, attr_name) && casted?(attr_name, attr_value, validator_value)

          @erroneous_attrs.add attr_name
          add_error validator_instance.error
        end
      end

      raise ValidationError, errors.to_s if should_raise?
    end

    protected

    attr_reader :instance, :errors

    def statinizer
      @statinizer ||= instance.class.statinizer
    end

    def attrs
      statinizer.attrs
    end

    def force?
      statinizer.force
    end

    def should_raise?
      force? || @erroneous_attrs.intersect?(forced_attributes.map(&:name))
    end

    def forced_attributes
      statinizer.forced_attributes
    end

    def casted_attributes
      statinizer.casted_attributes
    end

    def add_error(error)
      return if error.nil?

      @errors << error
    end

    private

    def validators_exist?
      attrs
        .flat_map(&:validators).uniq
        .reject { |validator| NOT_VALIDATORS.include? validator }
        .map(&:to_s).map(&:capitalize)
        .all? { |validator| Object.const_defined?("Statinize::#{validator}Validator") }
    end

    def should_cast?(validator, attr_name)
      validator == :type &&
        statinizer.casted_attributes.map(&:name).include?(attr_name)
    end

    def casted?(attr_name, attr_value, validator_value)
      ::Statinize::Caster.cast(instance, attr_name, attr_value, validator_value)
    end
  end
end
