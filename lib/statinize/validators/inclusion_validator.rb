module Statinize
  class InclusionValidator < Validator
    def valid?
      validator_value.is_a?(Array) && validator_value.include?(attr_value)
    end

    def error
      "should be one of #{validator_value.join(", ")}, got #{attr_value} instead"
    end
  end
end
