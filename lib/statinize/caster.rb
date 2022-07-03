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

    def initialize(instance, attr_name, attr_value, validator_value)
      @instance = instance
      @attr_name = attr_name
      @attr_value = attr_value
      @validator_value = validator_value
    end

    def cast
      return false unless castable?

      instance.public_send("#{attr_name}=", casted)
      true
    end

    def self.cast(instance, attr_name, attr_value, validator_value)
      new(instance, attr_name, attr_value, validator_value).cast
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
