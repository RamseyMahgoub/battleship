require 'rails_helper'

RSpec.describe GamePlayer, type: :model do
  it 'create creates a game player' do
    game = Game.new
    game.save

    game_player = GamePlayer.create(game, true, false)
    expect(game_player.game_id).to be(game.id)
    expect(game_player.active_turn).to be(true)
    expect(game_player.human_player).to be(false)
  end

  it 'create_human_player creates a human player' do
    game = Game.new
    game.save

    game_player = GamePlayer.create_human_player(game)
    expect(game_player.game_id).to be(game.id)
    expect(game_player.human_player).to be(true)
    expect(game_player.active_turn).to be(true)
  end

  it 'create_computer_player creates a computer player' do
    game = Game.new
    game.save

    game_player = GamePlayer.create_computer_player(game)
    expect(game_player.game_id).to be(game.id)
    expect(game_player.human_player).to be(false)
    expect(game_player.active_turn).to be(false)
  end


  it 'create_computer_player should create a grid' do
    game = Game.new
    game.save

    game_player = GamePlayer.create_computer_player(game)
    expect(game_player.grid).to be_kind_of(Grid)
  end

  it 'create_human_player should create a grid' do
    game = Game.new
    game.save

    game_player = GamePlayer.create_human_player(game)
    expect(game_player.grid).to be_kind_of(Grid)
  end
end
