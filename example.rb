require_relative "lib/statinize"

Statinize::Statinizer.configure do |config|
  # Every class by default will raise an error
  config.force = true
end

# class ExampleClass
#   include Statinize::Statinizable

#   statinize do
#     # Won't raise an error
#     force false
#     attribute :first_name, :last_name, type: String, force: true

#     # Will attempt to cast age to integer. Will raise an error if fails
#     attribute :age, presence: true, type: Integer, cast: true
#   end
# end

# begin
#   ExampleClass.new(last_name: 1)
# rescue Statinize::ValidationError => e
#   puts e.message
# end

# example2 = ExampleClass.new(first_name: "a", last_name: "b")
# pp example2.valid? # => false

# example3 = ExampleClass.new(first_name: "a", last_name: "b", age: "1")
# pp example3.valid? # => true

# Another example
class AnotherExampleClass
  include Statinize::Statinizable

  statinize do
    attribute :age
    attribute :first_name
    validate :age, presence: true, if: -> { first_name == "a" }
    validate :age, type: Integer, presence: true, if: -> { first_name == "b" }
    # [{type: Integer, presence: true , if: proc}, {presence: true, if: proc}]
  end
end

# begin
#   AnotherExampleClass.new
# rescue Statinize::ValidationError => e
#   puts e.message
# end
