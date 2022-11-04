require "set"
require "pry"
require "bigdecimal/util"
require_relative "statinize/statinizable"
require_relative "statinize/dsl"
require_relative "statinize/statinizer"
require_relative "statinize/configuration"
require_relative "statinize/attribute"
require_relative "statinize/attribute/options"
require_relative "statinize/attribute/options/conditions"
require_relative "statinize/attribute/options_collection"
require_relative "statinize/validator"
require_relative "statinize/validation"
require_relative "statinize/validators/type_validator"
require_relative "statinize/validators/presence_validator"
require_relative "statinize/validators/inclusion_validator"
require_relative "statinize/validators/nil_validator"
require_relative "statinize/caster"
require_relative "statinize/errors"

module Statinize
  def self.configure = yield Config
end
