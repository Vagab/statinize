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
        key?(:type) && key?(:cast)
      end

      def should_force?
        key? :force
      end

      def should_validate?(instance)
        return false if validators.empty?

        if !key?(:unless) && !key?(:if)
          true
        elsif key?(:unless) && !self[:unless].falsey?(instance)
          false
        else
          (key?(:if) && self[:if].truthy?(instance))
        end
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
