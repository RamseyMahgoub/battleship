class Cell < ApplicationRecord
  belongs_to :grid
  has_one :ship_cell
  has_one :ship, through: :ship_cell

  START_CHAR_CODE = 'A'.ord - 1

  def self.from_coord(coord)
    chars = coord.chars
    Cell.new(
      x: chars[0].upcase.ord - START_CHAR_CODE,
      y: chars.drop(1).join.to_i,
    )
  end

  def coord
    "#{(x + START_CHAR_CODE).chr}#{y}"
  end

  def connected_through_x?(cell)
    y == cell.y && (x == cell.x - 1 || x == cell.x + 1)
  end

  def connected_through_y?(cell)
    x == cell.x && (y == cell.y - 1 || y == cell.y + 1)
  end

  def contains_ship?
    !ship.nil?
  end

  def contains_sunk_ship?
    if ship
      ship.sunk?
    else
      false
    end
  end

  def state(revealing = false)
    if contains_sunk_ship?
      :sunk
    elsif targeted && contains_ship?
      :hit
    elsif targeted && !contains_ship?
      :miss
    elsif !targeted && contains_ship? && revealing
      :ship
    else
      :empty
    end
  end
end
