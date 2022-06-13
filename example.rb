require 'set'
require 'pry'
require_relative 'statinizable'
require_relative 'validator'
require_relative 'type_validator'
require_relative 'presence_validator'
require_relative 'attribute'
require_relative 'errors'
require_relative 'statinizer'

class ExampleClass
  include Statinizable

  statinize do
    attributes :first_name, :last_name, type: String
    attributes :age, type: Integer, presence: true
  end
end

example1 = ExampleClass.new(first_name: 'a', last_name: 'b', age: :a)
pp example1.valid? # => false

example2 = ExampleClass.new(first_name: 'a', last_name: 'b')
pp example2.valid? # => false

example3 = ExampleClass.new(first_name: 'a', last_name: 'b', age: 1)
pp example3.valid? # => true

# Another example
class AnotherExampleClass
  include Statinizable

  # will raise an error now
  statinize(force: true) do
    attributes :age, presence: true
  end
end

begin
  AnotherExampleClass.new
rescue ValidationError => e
  puts e.message
end
