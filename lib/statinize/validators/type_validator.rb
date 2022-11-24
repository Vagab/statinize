module Statinize
  class TypeValidator < Validator
    def valid?
      if validator_value.is_a? Class
        attr_value.is_a?(validator_value)
      elsif validator_value.is_a? Proc
        attr_value.is_a?(instance.instance_exec &validator_value)
      end || attr_value.nil?
    end

    def error
      "should be #{validator_value}, found #{attr_value.class} instead"
    end
  end
end
