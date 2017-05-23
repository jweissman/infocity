class Cartogram < ApplicationRecord
  def width
    structure[0].length
  end

  def height
    structure.length
  end

  def at(x,y)
    return nil unless contains?(x,y)
    structure[y][x]
  end

  def contains?(x,y)
    x >= 0 && y >= 0 &&
      x <= width && y <= height
  end
end
