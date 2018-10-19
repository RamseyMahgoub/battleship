class Cell < ApplicationRecord
  belongs_to :grid

  START_CHAR_CODE = 'A'.ord - 1

  def coord
    "#{(x + START_CHAR_CODE).chr}#{y}"
  end

  def self.from_coord(coord)
    chars = coord.chars
    Cell.new(
      x: chars[0].ord - START_CHAR_CODE,
      y: chars[1].to_i,
    )
  end
end
