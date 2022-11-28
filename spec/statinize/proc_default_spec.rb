RSpec.describe "Proc default" do
  subject { ProcDefaultDummy.new(params) }

  context "when proc default" do
    let!(:params) { {} }

    it "sets correct default" do
      expect(ProcDefaultDummy.new.a).to eq 1
      expect(ProcDefaultDummy.new.a).to eq 2
    end

    context "when proc is an instance method" do
      let!(:params) { { default: "b" } }

      it "works" do
        expect(subject.b).to eq "b"
      end
    end
  end
end

class ProcDefaultDummy
  include Statinize

  statinize do
    # any function which returns different things will do
    attribute :a, default_exec: -> { Counter.increment }
    attribute :b, default_exec: -> { default }
    attribute :default
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
