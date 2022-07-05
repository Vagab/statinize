module Statinize
  class Attribute
    class Options < Hash
      include Comparable

      def validators
        @validators ||= defined_validators
          .transform_keys { |validator| Object.const_get validator }
      end

      def all_validators_defined?
        validators_class_names
          .all? { |validator, _| Object.const_defined? validator }
      end

      def should_cast?
        key?(:type) && key?(:cast)
      end

      def should_force?
        key? :force
      end

      private

      def filtered_validators
        reject do |k, _|
          ::Statinize::Validator::NOT_VALIDATORS.include? k
        end
      end

      def defined_validators
        validators_class_names
          .select { |validator, _| Object.const_defined? validator }
      end

      def validators_class_names
        filtered_validators
          .transform_keys { |validator| "::Statinize::#{validator.to_s.capitalize}Validator" }
      end
    end
  end
end
