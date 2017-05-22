require 'rails_helper'

RSpec.describe Cartogram, type: :model do
  subject(:cartogram) do
    described_class.new
  end

  describe '#structure' do
    it 'is a nested-array description of area' do
      expect(cartogram.structure).to be_empty

      cartogram.structure << [1,2,3]
      cartogram.structure << [4,5,6]
      cartogram.save

      expect(cartogram.reload.structure).to eq([[1,2,3],[4,5,6]])
    end

    it 'is measured by width and height' do
      cartogram.structure << [1,2,3]
      cartogram.structure << [4,5,6]
      expect(cartogram.width).to eq(3)
      expect(cartogram.height).to eq(2)
    end
  end

  describe '#at' do
    it 'inspects structure' do
      cartogram.structure << [1,2,3]
      cartogram.structure << [4,5,6]

      # return value of structure
      expect(cartogram.at(0,0)).to eq(1)
      expect(cartogram.at(0,1)).to eq(4)
      expect(cartogram.at(1,0)).to eq(2)
      expect(cartogram.at(1,1)).to eq(5)

      # nil outside of region
      expect(cartogram.at(-1,-2)).to eq(nil)
      expect(cartogram.at(3,5)).to eq(nil)
    end
  end
end
