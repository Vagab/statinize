module Statinize
  module Statinizable
    def self.included(klass)
      klass.extend(ClassMethods)
      klass.prepend(PrependedMethods)
    end

    module PrependedMethods
      def initialize(*args, **kwargs)
        self.class.statinizer.attrs.map(&:name).each do |attr|
          instance_variable_set("@#{attr}", kwargs.delete(attr)) if kwargs.key?(attr)
        end

        define_validation

        validate!

        super(*args, **kwargs)
      end

      def validation
        @validation ||= Validation.new(statinizer, self)
      end

      alias_method :define_validation, :validation

      def statinizer
        self.class.statinizer
      end
    end

    module ClassMethods
      def statinize(&block)
        @statinizer = Statinizer.new(self)

        statinizer.instance_eval(&block)
      end

      def statinizer
        @statinizer
      end
    end
  end
end
