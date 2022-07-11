module Statinize
  class Beforer
    attr_reader :befored_attributes

    def initialize(klass)
      @befored_attributes = {}
      @klass = klass
    end

    def beforable?(attr)
      @befored_attributes.include?(attr)
    end

    def prework(attr_name, value)
      @befored_attributes[attr_name]&.call(value)
    end
  end
end
