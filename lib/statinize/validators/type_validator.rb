module Statinize
  class TypeValidator < Validator
    def valid?
      attr_value.is_a?(validator_value) || attr_value.nil?
    end

    def error
      { attr_name => "is not a #{validator_value}" }
    end
  end
end
