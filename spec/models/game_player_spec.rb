require 'rails_helper'

RSpec.describe GamePlayer, type: :model do
  let(:game) do
    game = Game.new
    game.save
    game
  end

  it 'create creates a game player' do
    game_player = GamePlayer.create(game, true, false)
    expect(game_player.game_id).to be(game.id)
    expect(game_player.active_turn).to be(true)
    expect(game_player.human_player).to be(false)
  end

  it 'create_human_player creates a human player' do
    game_player = GamePlayer.create_human_player(game)
    expect(game_player.game_id).to be(game.id)
    expect(game_player.human_player).to be(true)
    expect(game_player.active_turn).to be(true)
  end

  it 'create_computer_player creates a computer player' do
    game_player = GamePlayer.create_computer_player(game)
    expect(game_player.game_id).to be(game.id)
    expect(game_player.human_player).to be(false)
    expect(game_player.active_turn).to be(false)
  end


  it 'create_computer_player should create a grid' do
    game_player = GamePlayer.create_computer_player(game)
    expect(game_player.grid).to be_kind_of(Grid)
  end

  it 'create_human_player should create a grid' do
    game_player = GamePlayer.create_human_player(game)
    expect(game_player.grid).to be_kind_of(Grid)
  end

  context 'create_ships' do
    let(:game) do
       game = Game.new
       game.save
       game
    end
    let(:ship_a) { ShipType.create(name: 'a', size: 2) }
    let(:ship_b) { ShipType.create(name: 'b', size: 3) }

    let(:game_player) { GamePlayer.create(game, true, false) }

    it 'creates ships for the given valid array of ships' do
      ships = [{
        ship_type_id: ship_a.id,
        coords: ['A1', 'A2'],
      }, {
        ship_type_id: ship_b.id,
        coords: ['E4', 'E5', 'E6'],
      }]
      # TODO
      expect(game_player.create_ships(ships)).to be(true)
    end

    it 'returns false when no ships exist' do
      skip
      ships = []
      expect(game_player.create_ships(ships)).to be(false)
    end
  end
end
