require 'rails_helper'

RSpec.describe GamePlayer, type: :model do
  it 'create_human_player' do
    game = Game.new
    game.save

    game_player = GamePlayer.create_human_player(game.id)
    expect(game_player.game_id).to be(game.id)
    expect(game_player.human_player).to be(true)
    expect(game_player.active_turn).to be(true)
  end

  it 'create_computer_player' do
    game = Game.new
    game.save

    game_player = GamePlayer.create_computer_player(game.id)
    expect(game_player.game_id).to be(game.id)
    expect(game_player.human_player).to be(false)
    expect(game_player.active_turn).to be(false)
  end
end
