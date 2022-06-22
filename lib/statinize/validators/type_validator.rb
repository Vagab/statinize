module Statinize
  class TypeValidator < Validator
    def valid?
      attr_value.is_a?(validator_value) || attr_value.nil?
    end

    def error
      { attr_name => "should be #{validator_value}, found #{attr_value.class} instead" }
    end
  end
end
