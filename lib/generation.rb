module Generation
  def self.generate_structure(width:, height:)
    structure = Array.new(height) do
      Array.new(width) do
        (rand * 4).to_i
      end
    end
    1.times { structure = smooth_field(structure) }
    structure
  end

  def self.smooth_field(field)
    field.map.each_with_index do |row, y|
      row.map.each_with_index do |cell, x|
        average_neighbor_value(field, x, y)
      end
    end
  end

  def self.average_neighbor_value(field, cell_x, cell_y)
    total = 0
    count = 0
    (cell_x-1..cell_x+1).each do |x|
      (cell_y-1..cell_y+1).each do |y|
        if field[y] && field[y][x]
          total += field[y][x]
          count += 1
        end
      end
    end
    (total / count).to_i
  end
end
