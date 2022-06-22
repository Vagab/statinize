require_relative 'lib/statinize'

class ExampleClass
  include Statinize::Statinizable

  statinize do
    attributes :first_name, :last_name, type: String, force: true
    attributes :age, presence: true
  end
end

begin
  ExampleClass.new(last_name: 1)
rescue Statinize::ValidationError => e
  puts e.message
end

example2 = ExampleClass.new(first_name: 'a', last_name: 'b')
pp example2.valid? # => false

example3 = ExampleClass.new(first_name: 'a', last_name: 'b', age: 1)
pp example3.valid? # => true

# Another example
class AnotherExampleClass
  include Statinize::Statinizable

  # will raise an error now
  statinize(force: true) do
    attributes :age, presence: true
  end
end

begin
  AnotherExampleClass.new
rescue Statinize::ValidationError => e
  puts e.message
end
