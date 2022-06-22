module Statinize
  class Statinizer
    attr_reader :attrs, :force

    def initialize(klass, force)
      @klass = klass
      @force = force
      @attrs = Set.new
    end

    def add_attribute(attribute)
      @attrs.add(attribute)
    end

    def forced_attributes
      attrs.select { |attr| attr.validators.include? :force }
    end

    def casted_attributes
      attrs.select { |attr| attr.validators.include? :cast }
    end

    def attribute_exists?(attribute)
      attrs.include? attribute
    end
  end
end
