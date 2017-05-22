class Space < ApplicationRecord
  belongs_to :cartogram

  def dimensions
    [ cartogram.width, cartogram.height ]
  end
end
