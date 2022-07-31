require_relative "lib/statinize"

# Statinize::Statinizer.configure do |config|
#   # Every class by default will raise an error
#   config.force = true
# end

class ExampleClass
  include Statinize::Statinizable

  statinize do
    # Won't raise an error
    force false
    attribute :first_name, :last_name, type: String
    validate :first_name, inclusion: ["haha"], force: true, if: -> { last_name == "b" }
    validate :first_name, inclusion: ["hehe"], if: -> { last_name == "a" }

    # Will attempt to cast age to integer. Will raise an error if fails
    attribute :age, presence: true, type: Integer, cast: true
  end
end

begin
  ExampleClass.new(first_name: "a", last_name: "b")
rescue Statinize::ValidationError => e
  e.message # => ValidationError: ...
end

example2 = ExampleClass.new(first_name: "b", last_name: "a", age: 1)
example2.valid? # => false

example3 = ExampleClass.new(first_name: "a", last_name: "c", age: "1")
example3.valid? # => true

# Another example
class AnotherExampleClass
  include Statinize::Statinizable

  statinize do
    attribute :age
    attribute :first_name, :last_name
    validate :age, type: Integer, presence: true, if: -> { first_name == "b" }
    validate :age, presence: true, if: [-> { first_name == "aa" }, :rubyist?], unless: -> { last_name == "Matz" }
  end

  def rubyist?
    last_name.include? "Matz"
  end
end

begin
  AnotherExampleClass.new(first_name: "aa", last_name: "CoolMatz")
rescue Statinize::ValidationError => e
  e.message # => ValidationError: ...
end

example2 = AnotherExampleClass.new(first_name: "aa", last_name: "Matz") # notice no age here
example2.valid? # => true

begin
  AnotherExampleClass.new(first_name: "b", age: "1")
rescue Statinize::ValidationError => e
  e.message # => ValidationError: ...
end

class ExampleBlockValidation
  include Statinize::Statinizable

  statinize do
    force false
    attribute :name, :email

    with type: String, presence: true do
      attribute :password, :encrypted_password
      validate :name, :email, cast: true
    end

    attribute :age, presence: true

    with type: Symbol, presence: true, if: -> { age&.even? } do
      attribute :type, :status
    end
  end
end

# I am too lazy to include more examples for this one, but it works.
# Later it will all be documented

ExampleBlockValidation.new.valid? # => false

class ExampleStatinizeBeforeClass
  include Statinize::Statinizable

  statinize do
    before do
      first_name.upcase!
      last_name.downcase!
    end

    attribute :first_name, :last_name, type: String
  end
end

e = ExampleStatinizeBeforeClass.new(first_name: "hermes", last_name: "ATHENA")
e.first_name # => HERMES
e.last_name # => athena
