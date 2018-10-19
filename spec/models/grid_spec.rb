require 'rails_helper'

RSpec.describe Grid, type: :model do
  let(:game) { Game.create }
  let(:game_player) { game.get_player(game.human_game_player_id) }

  it 'create will make a grid for the game player' do
    grid = Grid.create(:game_player => game_player)
    expect(grid.game_player).to be(game_player)
  end

  it 'create_cells should make cells in a grid of size 1x1' do
    skip
    grid = Grid.create(:game_player => game_player)
    grid.create_cells(1)
    expect(grid.cells.length).to be(1)
    # expect(grid.cells.first.coord).to eq('A1')
  end
end
