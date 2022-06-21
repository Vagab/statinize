module Statinize
  module Statinizable
    def self.included(klass)
      klass.extend(ClassMethods)
      klass.prepend(PrependedMethods)
    end

    module PrependedMethods
      def initialize(*args, **kwargs)
        self.class.statinizer.attr_names.each do |attr|
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
        instance_variable_set('@statinizer', Statinizer.new(self, force))

        class_eval do
          def self.statinizer
            @statinizer
          end
        end

        block.call
      end

      def attributes(*attrs, **options)
        attrs.each do |attr|
          Attribute.create(self, attr, options)
        end
      end
    end
  end
end
