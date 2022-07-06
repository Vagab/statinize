module Statinize
  class Attribute
    class OptionsCollection < Array
      def all_validators_defined?
        raise "Not an option!" unless all? { _1.respond_to? :validators }

        all?(&:all_validators_defined?)
      end
    end
  end
end
