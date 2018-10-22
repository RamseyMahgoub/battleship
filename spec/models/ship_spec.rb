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

  it 'cells returns an array of grid cells for the ship' do
    ship = Ship.create_on_grid(game_player, ship_type, ['B1', 'B2'])
    expect(ship.cells.size).to be(2)
    expect(ship.cells[0].coord).to eq('B1')
    expect(ship.cells[1].coord).to eq('B2')
    expect(ship.cells[0].grid).to eq(game_player.grid)
  end

  it 'sunk returns if the ship is still alive or not' do
    ship = Ship.create_on_grid(game_player, ship_type, ['B1', 'B2'])
    expect(ship.sunk?).to be(false)
    ship.cells[0].targeted = true
    expect(ship.sunk?).to be(false)
    ship.cells[1].targeted = true
    expect(ship.sunk?).to be(true)
  end
end
