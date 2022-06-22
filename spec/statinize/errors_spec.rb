RSpec.describe Statinize::Errors do
  subject { described_class.new([{ name: 'is cool' }, { age: 'is not cool' }]) }

  # describe '#to_s' do
  #   it 'correctly formats' do
  #     expect(subject.to_s).to eq 'Name is cool, Age is not cool'
  #   end
  # end
end
