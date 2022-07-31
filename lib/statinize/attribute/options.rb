module Statinize
  class Attribute
    module Options
      def self.extended(instance)
        raise "Cannot extend #{instance}" unless instance.is_a? Hash

        instance.transform_values! do |value|
          if %i[if unless].include?(instance.key(value))
            Conditions.new(Array(value))
          else
            value
          end
        end
      end

      def validators
        @validators ||= defined_validators
          .transform_keys { |validator| Object.const_get validator }
      end

      def all_validators_defined?
        validators_class_names
          .all? { |validator, _| Object.const_defined? validator }
      end

      def should_cast?
        key?(:type) && public_send(:[], :cast)
      end

      def should_validate?(instance)
        return false if validators.empty?
        return true unless key?(:unless) || key?(:if)
        return false if key?(:unless) && !unless_passed?(instance)

        if_passed?(instance)
      end

      private

      def unless_passed?(instance)
        self[:unless].falsey?(instance)
      end

      def if_passed?(instance)
        self[:if].truthy?(instance)
      end

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
