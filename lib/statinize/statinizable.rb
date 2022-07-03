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

        validator.validate

        super(*args, **kwargs)
      end

      def valid?
        validator.valid?
      end

      def errors
        validator.errors
      end

      private

      def validator
        Validator.new(self)
      end
    end

    module ClassMethods
      def statinize(force: false, &block)
        @statinizer = Statinizer.new(self, force)

        class_eval do
          def self.statinizer
            @statinizer
          end
        end

        statinizer.instance_eval(&block)
      end
    end
  end
end
