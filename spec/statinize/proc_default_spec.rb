RSpec.describe "Proc default" do
  context "when proc default" do
    it "sets correct default" do
      expect(ProcDefaultDummy.new.a).to eq 1
      expect(ProcDefaultDummy.new.a).to eq 2
    end
  end
end

class ProcDefaultDummy
  include Statinize

  statinize do
    # any function which returns different things will do
    attribute :a, default_exec: -> { Counter.increment }
  end
end

class Counter
  require "singleton"
  include Singleton

  attr_accessor :counter

  def initialize
    @counter = 0
  end

  def self.increment
    instance.counter += 1
  end
end
