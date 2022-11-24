module Statinize
  class Validator
    NOT_VALIDATORS = %i[force cast if unless default default_exec name]

    attr_accessor :attr_value, :validator_value, :instance

    def initialize(attr_value, validator_value, instance)
      @attr_value = attr_value
      @validator_value = validator_value
      @instance = instance
    end

    def valid?
      raise NoMethodError, "#valid? method is not implemented on a #{self.class}"
    end

    def error
      raise NoMethodError, "#error method is not implemented on a #{self.class}"
    end
  end
end
