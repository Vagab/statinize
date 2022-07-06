module Statinize
  class PresenceValidator < Validator
    def valid?
      validator_value &&
        !empty_array? &&
        !empty_hash? &&
        !empty_string? &&
        !attr_value.nil?
    end

    def error
      "is blank"
    end

    private

    def empty_array?
      attr_value == []
    end

    def empty_hash?
      attr_value == {}
    end

    def empty_string?
      attr_value == ""
    end
  end
end
