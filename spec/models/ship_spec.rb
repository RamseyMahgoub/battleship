require 'rails_helper'

RSpec.describe Ship, type: :model do
  let(:game) do
    game = Game.new
    game.save
    game
  end
  let(:ship_type) { ShipType.create(name: 'a', size: 2) }
  let(:game_player) { GamePlayer.create(game, true, false) }

  it 'create_on_grid makes a ship on the game player' do
    ship = Ship.create_on_grid(game_player, ship_type, ['B1', 'B2'])
    expect(game_player.ships.first).to eq(ship)
  end

  it 'create_on_grid makes ship_cells linked to the grid cells' do
    ship = Ship.create_on_grid(game_player, ship_type, ['B1', 'B2'])
    ship_cell_1 = ship.ship_cells.first.cell
    ship_cell_2 = ship.ship_cells.last.cell

    expect(ship_cell_1.grid).to eq(game_player.grid)
    expect(ship_cell_2.grid).to eq(game_player.grid)
  end

  it 'create_on_grid makes ship_cells in the correct cells on the grid' do
    ship = Ship.create_on_grid(game_player, ship_type, ['B1', 'B2'])
    ship_cell_1 = ship.ship_cells.first.cell
    ship_cell_2 = ship.ship_cells.last.cell

    expect(ship_cell_1.coord).to eq('B1')
    expect(ship_cell_2.coord).to eq('B2')
  end
end
