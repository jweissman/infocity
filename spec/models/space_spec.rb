require 'rails_helper'

RSpec.describe Space, type: :model do
  subject(:space) do
    described_class.new(name: 'eternia')
  end

  it 'has a name' do
    expect(space.name).to eq 'eternia'
  end

  it 'has a cartogram' do
    expect(space.cartogram).to be_nil
    space.create_cartogram(structure: [[1,2,3],[4,5,6]])
    expect(space.dimensions).to eq([3,2])
  end
end
