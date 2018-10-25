class ShipCell < ApplicationRecord
  belongs_to :ship
  belongs_to :cell

  def piece
    index = ship.ship_cells.index(self)

    if ship.cells.first.connected_through_x?(ship.cells[1])
      return :south if index == 0
      return :north if index == ship.cells.size - 1
      return :vertical
    else
      return :east if index == 0
      return :west if index == ship.cells.size - 1
      return :horizontal
    end
  end
end
