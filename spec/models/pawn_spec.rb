require 'rails_helper'

RSpec.describe Pawn, type: :model do
  it 'has a name and status' do
    pawn = described_class.new(name: 'bob', status: 'hi')
    expect(pawn.name).to eq('bob')
    expect(pawn.status).to eq('hi')
  end

  it 'can belong to a space' do
    space = Space.new
    pawn = described_class.new(space: space)
    expect(pawn.space).to eq(space)
  end

  it 'can be moved' do
    pawn = described_class.new(x: 10, y: 10)
    expect { pawn.go('north') }.to change { pawn.y }.by(-1)
    expect { pawn.go('south') }.to change { pawn.y }.by(1)
    expect { pawn.go('east') }.to change { pawn.x }.by(-1)
    expect { pawn.go('west') }.to change { pawn.x }.by(1)
  end
end
