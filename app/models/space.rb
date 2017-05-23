class Space < ApplicationRecord
  belongs_to :cartogram
  has_many :management_keys

  def dimensions
    [ cartogram.width, cartogram.height ]
  end
end
