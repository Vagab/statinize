module Statinize
  class NotStatinizableError < StandardError; end

  class ValidationError < StandardError; end

  class NoSuchValidatorError < StandardError; end

  class Errors < Array
    def to_s
      map do |i|
        "#{i.keys.first.to_s.capitalize} #{i.values.first}"
      end.join(', ')
    end
  end
end
