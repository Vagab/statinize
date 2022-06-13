class TypeValidator < Validator
  def self.validate(attr, value, klass)
    return if value.is_a?(klass) || value.nil?

    { attr => "is not a #{klass}" }
  end
end
