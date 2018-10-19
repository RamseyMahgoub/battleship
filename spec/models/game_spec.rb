require 'rails_helper'

# rails generate rspec:model game

RSpec.describe Game, type: :model do
  it 'creates a game' do
    game = Game.create
    expect(game.id).to be_kind_of(Fixnum)
  end

  it 'create will make 2 game_players' do
    game = Game.create
    expect(game.game_players.length).to be(2)
  end

  it 'human_game_player_id returns the human id' do
    game = Game.create
    game_player = game.game_players.find { |game_player| game_player.human_player }
    expect(game.human_game_player_id).to be(game_player.id)
  end

  it 'create will make 1 "computer" player' do
    game = Game.create
    game_players = game.game_players.select { |game_player| game_player.id != game.human_game_player_id }
    expect(game_players.length).to be(1)
    expect(game_players[0].human_player).to be(false)
    expect(game_players[0].active_turn).to be(false)
  end

  it 'create will make 1 "human" player with active turn' do
    game = Game.create
    game_players = game.game_players.select { |game_player| game_player.id == game.human_game_player_id }
    expect(game_players.length).to be(1)
    expect(game_players[0].human_player).to be(true)
    expect(game_players[0].active_turn).to be(true)
  end

  it 'get_player will return the game_player for an id' do
    game = Game.create
    game_player = game.game_players[0]

    expect(game.get_player(game_player.id)).to eq(game_player)
  end
end
