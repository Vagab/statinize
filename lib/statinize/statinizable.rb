module Statinize
  module Statinizable
    def self.included(klass)
      klass.extend(ClassMethods)
      klass.prepend(PrependedMethods)

      statinized_ancestors = klass.ancestors
        .reject { |a| a == klass || a == Statinize::Statinizable }
        .select { |a| a.ancestors.include? Statinize::Statinizable }

      if statinized_ancestors.any?
        klass.instance_variable_set("@statinizer", Statinizer.new(klass))

        statinized_ancestors.each do |ancestor|
          klass.statinizer.populate(ancestor.statinizer.attributes) if ancestor.statinizer
        end
      end
    end

    module PrependedMethods
      def initialize(options = {}, *args, &block)
        symbolized = options.transform_keys(&:to_sym)

        if private_methods(false).include? :initialize
          super(options, *args, &block)
          check_defined!(symbolized)
        else
          statinizer.attributes.each do |attr|
            instance_variable_set("@#{attr.name}", symbolized[attr.arg_name]) if symbolized.key?(attr.arg_name)
          end
        end

        instantiate_defaults

        run_before_callbacks

        define_validation
        validate!
      end

      def validation
        @validation ||= Validation.new(statinizer, self)
      end

      def run_before_callbacks
        statinizer.run_before_callbacks(self)
      end

      def attributes
        @attributes = Hash[
          statinizer.attributes.map { |a| [a.name, public_send(a.name)] }
        ]
      end

      alias_method :define_validation, :validation

      def statinizer
        self.class.statinizer
      end

      private

      def check_defined!(options)
        statinizer.attributes.map(&:name).each do |attr|
          undefined_attrs << attr unless options.key?(attr)
        end

        raise UndefinedAttributeError, "Not all attributes defined in statinize block are defined in initialize"
      end

      def instantiate_defaults
        undefined_attributes = statinizer.attributes.select do |attribute|
          public_send(attribute.name).nil?
        end

        undefined_attributes.select { |a| a.options.key?(:default) }.each do |attribute|
          public_send("#{attribute.name}=", attribute.default.deep_dup)
        end

        undefined_attributes.select { |a| a.options.key?(:default_exec) }.each do |attribute|
          public_send("#{attribute.name}=", instance_exec(&attribute.default_exec))
        end
      end
    end

    module ClassMethods
      def statinize(&block)
        @statinizer = Statinizer.new(self) unless @statinizer

        statinizer.instance_eval(&block)

        statinizer.check_validators_exist!
      end

      def statinizer
        @statinizer
      end

      def inherited(klass)
        super(klass)
        klass.include(Statinize::Statinizable)
      end
    end
  end
end
