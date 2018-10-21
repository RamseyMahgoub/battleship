require 'rails_helper'

RSpec.describe Cell, type: :model do
  let(:game) { Game.create }
  let(:game_player) { game.get_player(game.human_game_player_id) }

  it 'coord returns the alpha-numeric coord string for 1,1' do
    cell = Cell.create(
      grid: game_player.grid,
      x: 1,
      y: 1,
    )

    expect(cell.coord).to eq('A1')
  end

  it 'coord returns the alpha-numeric coord string 3,2' do
    cell = Cell.create(
      grid: game_player.grid,
      x: 3,
      y: 2,
    )

    expect(cell.coord).to eq('C2')
  end

  it 'from_coord returns the cell from an alpha-numeric coord string' do
    cell = Cell.from_coord('B3')
    expect(cell.x).to be(2)
    expect(cell.y).to be(3)
  end

  it 'from_coord returns the cell from an lowercase alpha-numeric coord string' do
    cell = Cell.from_coord('b3')
    expect(cell.x).to be(2)
    expect(cell.y).to be(3)
  end

  it 'connected_through_x returns true if x is within 1 and y same' do
    cellA = Cell.from_coord('A3')
    cellB = Cell.from_coord('B3')
    cellC = Cell.from_coord('C3')

    expect(cellA.connected_through_x?(cellB)).to be(true)
    expect(cellB.connected_through_x?(cellA)).to be(true)
    expect(cellB.connected_through_x?(cellC)).to be(true)
  end

  it 'connected_through_x returns false if x isnt within 1 or y different' do
    cellA = Cell.from_coord('A3')
    cellB = Cell.from_coord('C3')
    cellC = Cell.from_coord('D4')
    cellD = Cell.from_coord('D5')

    expect(cellA.connected_through_x?(cellB)).to be(false)
    expect(cellB.connected_through_x?(cellA)).to be(false)
    expect(cellB.connected_through_x?(cellC)).to be(false)
    expect(cellC.connected_through_x?(cellB)).to be(false)
    expect(cellC.connected_through_x?(cellD)).to be(false)
  end

  it 'connected_through_y returns true if y is within 1 and x same' do
    cellA = Cell.from_coord('C3')
    cellB = Cell.from_coord('C4')
    cellC = Cell.from_coord('C5')

    expect(cellA.connected_through_y?(cellB)).to be(true)
    expect(cellB.connected_through_y?(cellA)).to be(true)
    expect(cellB.connected_through_y?(cellC)).to be(true)
  end

  it 'connected_through_y returns false if y isnt within 1 or x different' do
    cellA = Cell.from_coord('C1')
    cellB = Cell.from_coord('C3')
    cellC = Cell.from_coord('D4')
    cellD = Cell.from_coord('E4')

    expect(cellA.connected_through_y?(cellB)).to be(false)
    expect(cellB.connected_through_y?(cellA)).to be(false)
    expect(cellB.connected_through_y?(cellC)).to be(false)
    expect(cellC.connected_through_y?(cellB)).to be(false)
  end

  context 'once ships are placed' do
    let(:ship_type) { ShipType.create(name: 'a', size: 2) }
    let(:ship) { Ship.create_on_grid(game_player, ship_type, ['B1', 'B2']) }

    let(:cell_with_no_ship) { game_player.grid.find_cell_by_coord('A1') }
    let(:cell_with_ship) { game_player.grid.find_cell_by_coord('B1') }

    it 'contains_ship? returns if there is not a ship in the cell' do
      expect(cell_with_no_ship.contains_ship?).to be(false)
    end

    it 'contains_ship? returns if there is a ship in the cell' do
      expect(cell_with_ship.id == ship.cells.first.id).to be(true)
      expect(cell_with_ship.contains_ship?).to be(true)
    end

    it 'ship returns the ship of the cell if one exists' do
      expect(cell_with_ship.id == ship.cells.first.id).to be(true)
      expect(cell_with_ship.ship).to eq(ship)
    end

    it 'ship returns nil if one does not exist' do
      expect(cell_with_ship.ship).to eq(nil)
    end

    # TODO non revealing and revealing
    context 'non revealing' do


      it 'state returns ":empty" if not hit and no ship' do
        skip
        expect(cell.state).to be(:empty)
      end
    end
  end
end
