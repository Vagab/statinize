# Defines DSL for statinize block
module Statinize
  module DSL
    def attribute(*attrs, **options)
      attrs.each do |attr|
        Attribute.create(klass, attr, options) unless attribute? attr
      end
    end

    def validate(*attrs, **options)
      attrs.each do |attr|
        attribute = attributes.find { _1.name == attr }
        attribute = Attribute.create(klass, attr) unless attribute
        attribute.add_options(options)
      end
    end

    def with(**options, &block)
      # create new statinizer instance
      instance = self.class.new(klass)
      instance.force(force)

      # execute block in the context of that statinizer
      # while it's attached to the klass
      # then rewind and attach the original statinizer(self)
      # back to the klass
      klass.instance_variable_set(:@statinizer, instance)
      instance.instance_exec(&block)
      klass.instance_variable_set(:@statinizer, self)

      # merge the newly created statinizer with the options
      instance.merge_options(**options)

      # populate self with the instance's attributes
      populate(instance.attributes)
    end

    def before(&block)
      return unless block_given?

      before_callbacks << block
    end

    def force(force = nil)
      force.nil? ? @force : @force = force
    end
  end
end
