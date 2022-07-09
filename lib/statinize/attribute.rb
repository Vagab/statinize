module Statinize
  class Attribute
    include Comparable

    attr_reader :klass, :name, :options

    def initialize(klass, name, opts)
      @klass = klass
      @name = name
      @options = OptionsCollection.new
      @options << opts.clone.extend(Options) unless opts.empty?
      beforer.hh[name] = opts[:before] if opts.key?(:before)
    end

    def self.create(klass, name, opts)
      new(klass, name, opts).create
    end

    def create
      statinizer.add_attribute(self) unless attribute?
      klass.class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def #{name}
          @#{name}
        end

        def #{name}=(attr)
          @#{name} = attr
          validate if respond_to?(:validate)
          attr
        end
      RUBY_EVAL
      self
    end

    def add_options(opts)
      options << opts.extend(Options)
    end

    def <=>(other)
      name == other.name &&
        options == other.options &&
        klass == other.klass
    end

    private

    def beforer
      statinizer.beforer
    end

    def statinizer
      klass.statinizer
    end

    def attribute?
      statinizer.attribute?(self)
    end
  end
end
