module Statinize
  class Attribute
    include Comparable

    attr_reader :klass, :name, :default
    attr_accessor :options_collection, :options

    def initialize(klass, name, options)
      @klass = klass
      @name = name
      @options = options
      @options_collection = OptionsCollection.new # TODO: think of a better way
      @options_collection << options.clone.extend(Options) unless options.empty?

      @default = options[:default] if options.key?(:default)
    end

    def self.create(klass, name, options = {})
      new(klass, name, options).create
    end

    def create
      attribute? ? override : add_attribute

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
      options_collection << opts.extend(Options)
    end

    def <=>(other)
      name == other.name &&
        options == other.options &&
        klass == other.klass
    end

    private

    def override
      attribute = statinizer.attributes.find { |a| a.name == name }
      attribute.options_collection = options_collection
      attribute.options = options
    end

    def add_attribute
      statinizer.add_attribute(self)
    end

    def statinizer
      klass.statinizer
    end

    def attribute?
      statinizer.attribute?(self)
    end
  end
end
