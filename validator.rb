class Validator
  def initialize(instance, force)
    raise NotStatinizableError unless instance&.class&.statinizer.is_a?(Statinizer)

    @instance = instance
    @force = force
    @errors = []
  end

  def validate!
    raise ValidationError, errors.to_s if force && invalid?
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
    options.each do |attr, validator_options|
      validator_options.each do |validator, value|
        validator = Object.const_get("#{validator.to_s.capitalize}Validator")
        add_error(validator.validate(attr, instance.public_send(attr), value))
      rescue NameError
        raise NoSuchValidatorError
      end
    end
  end

  protected

  attr_reader :instance, :errors, :force

  def statinizer
    @statinizer ||= instance.class.statinizer
  end

  def options
    statinizer.options
  end

  def attrs
    statinizer.attrs
  end

  def add_error(error)
    return if error.nil?

    @errors << error
  end
end
