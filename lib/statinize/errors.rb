module Statinize
  class ValidationError < StandardError; end

  class NoSuchValidatorError < StandardError; end

  class InvalidConditionError < StandardError; end

  class UndefinedAttributeError < StandardError; end

  class UnknownAttributeError < StandardError; end

  class Errors < Hash
    def nice
      nice_errors = map do |attr_name, errors|
        errors.map do |error|
          "#{attr_name.to_s.split("_").tap { |attr| attr.first.capitalize! }.join(" ")} #{error}"
        end.join("; ")
      end.join("; ")

      "ValidationError: #{nice_errors}"
    end
  end
end
