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
end
