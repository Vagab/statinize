module Statinizable
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.prepend(PrependedMethods)
  end

  module PrependedMethods
    def initialize(**attrs)
      attrs.each do |attr, value|
        instance_variable_set("@#{attr}", value)
      end

      validator.validate!
    end

    def valid?
      validator.valid?
    end

    def errors
      validator.errors
    end

    private

    def validator
      Validator.new(self, self.class.statinizer.force)
    end
  end

  module ClassMethods
    def statinize(force: false, &block)
      instance_variable_set("@statinizer", Statinizer.new(self, force))

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
