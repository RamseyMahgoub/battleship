class Cell < ApplicationRecord
  belongs_to :grid

  START_CHAR_CODE = 'A'.ord - 1

  def coord
    "#{(x + START_CHAR_CODE).chr}#{y}"
  end
end
