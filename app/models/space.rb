class Space < ApplicationRecord
  belongs_to :cartogram # weird directionality there
  has_many :pawns
  has_many :management_keys

  def dimensions
    [ cartogram.width, cartogram.height ]
  end
end
