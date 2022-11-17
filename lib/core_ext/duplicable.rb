# https://github.com/rails/rails/blob/main/activesupport/lib/active_support/core_ext/object/duplicable.rb

class Object
  # Can you safely dup this object?
  #
  # False for method objects;
  # true otherwise.
  def duplicable?
    true
  end
end

class Method
  # Methods are not duplicable:
  #
  #   method(:puts).duplicable? # => false
  #   method(:puts).dup         # => TypeError: allocator undefined for Method
  def duplicable?
    false
  end
end

class UnboundMethod
  # Unbound methods are not duplicable:
  #
  #   method(:puts).unbind.duplicable? # => false
  #   method(:puts).unbind.dup         # => TypeError: allocator undefined for UnboundMethod
  def duplicable?
    false
  end
end

require "singleton"

module Singleton
  # Singleton instances are not duplicable:
  #
  #   Class.new.include(Singleton).instance.dup # TypeError (can't dup instance of singleton
  def duplicable?
    false
  end
end
