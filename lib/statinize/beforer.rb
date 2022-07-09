module Statinize
  class Beforer
    attr_accessor :hh

    def initialize(klass)
      @hh = {}
      @klass = klass
    end

    def beforable?(attr)
      @hh.include?(attr)
    end

    def prework(attr_name, value)
      @hh[attr_name]&.call(value)
    end
  end
end
