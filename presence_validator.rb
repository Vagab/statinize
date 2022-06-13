class PresenceValidator < Validator
  def self.validate(name, value, validator_value)
    return unless validator_value
    return unless value.nil? || value == [] || value == {} || value == ''

    { name => 'is blank' }
  end
end
