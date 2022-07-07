module Statinize
  module Statinizable
    def self.included(klass)
      klass.extend(ClassMethods)
      klass.prepend(PrependedMethods)
    end

    module PrependedMethods
      def initialize(*args, **kwargs, &block)
        if private_methods(false).include? :initialize
          super(*args, **kwargs, &block)
          check_defined!(kwargs)
        else
          statinizer.attributes.map(&:name).each do |attr|
            instance_variable_set("@#{attr}", kwargs[attr]) if kwargs.key?(attr)
          end
        end

        define_validation
        validate!
      end

      def validation
        @validation ||= Validation.new(statinizer, self)
      end

      alias_method :define_validation, :validation

      def statinizer
        self.class.statinizer
      end

      private

      def check_defined!(kwargs)
        statinizer.attributes.map(&:name).each do |attr|
          undefined_attrs << attr if public_send(attr) != kwargs[attr] || !kwargs.key?(attr)
        end

        raise UndefinedAttributeError, "Not all attributes defined in statinize block are not defined in initialize"
      end
    end

    module ClassMethods
      def statinize(&block)
        @statinizer = Statinizer.new(self)

        statinizer.instance_eval(&block)

        statinizer.check_validators_exist!
      end

      def statinizer
        @statinizer
      end
    end
  end
end
