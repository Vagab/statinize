module Statinize
  class Attribute
    module Options
      class Conditions < Array
        def truthy?(instance)
          all? do |condition|
            if condition.is_a?(Symbol)
              !!condition.to_proc.call(instance)
            elsif condition.lambda?
              !!instance.instance_exec(&condition)
            elsif condition.is_a?(Proc)
              !!condition.call(instance)
            else
              raise InvalidConditionError, "condition should be a Symbol, Proc, or a lambda"
            end
          end
        end

        def falsey?(instance)
          all? do |condition|
            if condition.is_a?(Symbol)
              !condition.to_proc.call(instance)
            elsif condition.lambda?
              !instance.instance_exec(&condition)
            elsif condition.is_a?(Proc)
              !condition.call(instance)
            else
              raise InvalidConditionError, "condition should be a Symbol, Proc, or a lambda"
            end
          end
        end
      end
    end
  end
end
