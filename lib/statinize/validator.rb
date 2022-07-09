module Statinize
  class Validator
    NOT_VALIDATORS = %i[force cast if unless before]

    attr_accessor :attr_value, :validator_value

    def initialize(attr_value, validator_value)
      @attr_value = attr_value
      @validator_value = validator_value
    end

    def valid?
      raise NoMethodError, "#valid? method is not implemented on a #{self.class}"
    end

    def error
      raise NoMethodError, "#error method is not implemented on a #{self.class}"
    end
  end
end
