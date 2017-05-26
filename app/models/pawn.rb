class Pawn < ApplicationRecord
  belongs_to :space
  has_many :pawn_keys

  def go(direction)
    case direction
    when 'north' then update(y: y - 1)
    when 'south' then update(y: y + 1)
    when 'east'  then update(x: x - 1)
    when 'west'  then update(x: x + 1)
    else raise "Unknown direction #{direction} (must be north/south/east/west)"
    end
  end

  def self.for_key(value:)
    pawn_key = PawnKey.find_by(value: value)
    pawn_key.pawn if pawn_key
  end
end
