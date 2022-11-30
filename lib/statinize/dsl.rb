# Defines DSL for statinize block
module Statinize
  module DSL
    alias with with_options

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

    def before(&block)
      return unless block_given?

      before_callbacks << block
    end

    def force(force = nil)
      force.nil? ? @force : @force = force
    end
  end
end
