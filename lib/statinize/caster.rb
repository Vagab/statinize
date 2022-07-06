module Statinize
  class Caster
    TYPE_CASTINGS = {
      Integer => :to_i,
      String => :to_s,
      Float => :to_f,
      Complex => :to_c,
      Rational => :to_r,
      Symbol => :to_sym,
      Enumerator => :to_enum,
      Proc => :to_proc,
    }.freeze

    def initialize(instance, attr, option)
      @instance = instance
      @attr_name = attr.name
      @attr_value = instance.public_send(attr_name)
      @validator_value = option[:type]
    end

    def cast
      return false unless castable?

      instance.public_send("#{attr_name}=", casted)
      true
    end

    private

    attr_reader :instance, :attr_name, :attr_value, :validator_value

    def castable?
      attr_value.respond_to? casting
    end

    def casting
      @casting ||= TYPE_CASTINGS[validator_value]
    end

    def casted
      @casted ||= attr_value.public_send(casting)
    end
  end
end
