module Statinize
  class Configuration
    include Singleton

    attr_accessor :force

    def self.configure
      yield instance if block_given?
    end
  end
end
