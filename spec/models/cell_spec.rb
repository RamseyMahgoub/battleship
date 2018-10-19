require 'rails_helper'

RSpec.describe Cell, type: :model do
  let(:game) { Game.create }
  let(:game_player) { game.get_player(game.human_game_player_id) }

  it 'coord should return the AlphaNumeric coord string' do
    cell = Cell.create(
      :grid_id => game_player.grid.id,
      :x => 1,
      :y => 1,
    )

    expect(cell.coord2).to eq('A1')
  end
end
