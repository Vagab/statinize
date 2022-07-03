module Statinize
  class NotStatinizableError < StandardError; end

  class ValidationError < StandardError; end

  class NoSuchValidatorError < StandardError; end

  class UncastableAttributeError < StandardError; end

  class Errors < Array
    def to_s
      nice_errors = map do |i|
        "#{i.keys.first.to_s.split("_").tap { |attr| attr.first.capitalize! }.join(" ")} #{i.values.first}"
      end.join("; ")

      "ValidationError: #{nice_errors}"
    end
  end
end
