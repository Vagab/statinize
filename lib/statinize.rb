require "set"
require "pry"
require "bigdecimal/util"
require "statinize/statinizable"
require "statinize/dsl"
require "statinize/statinizer"
require "statinize/configuration"
require "statinize/attribute"
require "statinize/attribute/options"
require "statinize/attribute/options/conditions"
require "statinize/attribute/options_collection"
require "statinize/validator"
require "statinize/validation"
require "statinize/validators/type_validator"
require "statinize/validators/presence_validator"
require "statinize/validators/inclusion_validator"
require "statinize/validators/nil_validator"
require "statinize/caster"
require "statinize/errors"

module Statinize
  def self.included(klass)
    klass.include(Statinize::Statinizable)
  end

  def self.configure = yield Config
end
