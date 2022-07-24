module Statinize
  class ValidationError < StandardError; end

  class NoSuchValidatorError < StandardError; end

  class InvalidConditionError < StandardError; end

  class UndefinedAttribute < StandardError; end

  class Errors < Array
    def to_s
      nice_errors = map do |i|
        ">>> #{i.keys.first.to_s.split("_").tap { |attr| attr.first.capitalize! }.join(" ")} #{i.values.first}"
      end.join(";\n")

      "\nValidationError:\n#{nice_errors}"
    end
  end
end
