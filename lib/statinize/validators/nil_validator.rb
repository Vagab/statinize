module Statinize
  class NilValidator < Validator
    def valid?
      return true if validator_value

      !attr_value.nil?
    end

    def error
      "is nil"
    end
  end
end
