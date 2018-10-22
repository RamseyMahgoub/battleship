class Ship < ApplicationRecord
  belongs_to :game_player
  belongs_to :ship_type
  has_many :ship_cells
  has_many :cells, through: :ship_cells

  def self.create_on_grid(game_player, ship_type, coords)
    ship = Ship.create(ship_type: ship_type, game_player: game_player)
    coords.each do |coord|
      ship.ship_cells.create(cell: game_player.grid.find_cell_by_coord(coord))
    end

    ship
  end

  def sunk?
    cells.all? { |cell| cell.targeted }
  end
end
