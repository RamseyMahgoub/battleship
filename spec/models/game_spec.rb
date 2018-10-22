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

  it 'computer_game_player_id returns the computer id' do
    game = Game.create
    game_player = game.game_players.find { |game_player| !game_player.human_player }
    expect(game.computer_game_player_id).to be(game_player.id)
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

  it 'result will return nil if neither player has won yet' do
    game = Game.create
    game_player_1 = game.get_player(game.computer_game_player_id)
    game_player_2 = game.get_player(game.human_game_player_id)
    ship_type = ShipType.create(name: 'a', size: 2)
    Ship.create_on_grid(game_player_1, ship_type, ['B1', 'B2'])
    Ship.create_on_grid(game_player_2, ship_type, ['C1', 'D1'])

    expect(game.result).to be(nil)
  end

  it 'result will return the winning game_player once a player has won' do
    game = Game.create
    game_player_1 = game.get_player(game.computer_game_player_id)
    game_player_2 = game.get_player(game.human_game_player_id)
    ship_type = ShipType.create(name: 'a', size: 2)
    Ship.create_on_grid(game_player_1, ship_type, ['B1', 'B2'])
    ship = Ship.create_on_grid(game_player_2, ship_type, ['C1', 'D1'])


    expect(game.result).to be(nil)
    game.game_players[1].ships[0].cells.first.update(targeted: true)
    expect(game.result).to be(nil)
    game.game_players[1].ships[0].cells.last.update(targeted: true)
    expect(game.result).to eq(game_player_1)
  end

  it 'result will return nil if game is not setup yet' do
    game = Game.create
    expect(game.result).to be(nil)
  end

  it 'target will shoot at a cell and return true if successful' do
    game = Game.create
    game_player_1 = game.get_player(game.computer_game_player_id)
    game_player_2 = game.get_player(game.human_game_player_id)
    ship_type = ShipType.create(name: 'a', size: 2)
    Ship.create_on_grid(game_player_1, ship_type, ['B1', 'B2'])
    ship = Ship.create_on_grid(game_player_2, ship_type, ['C1', 'D1'])

    expect(game.target('F6')).to be(true)
    expect(game.game_players[0].grid.find_cell_by_coord('F6').targeted).to be(true)
  end

  it 'change_turn will change the active turn and return true if successful' do
    game = Game.create
    game_player = game.get_player(game.computer_game_player_id)

    expect(game.game_players[0].active_turn).to be(false)
    expect(game.game_players[1].active_turn).to be(true)

    game.game_players[0].update(turn_has_targeted: true)
    expect(game.change_turn).to be(true)

    expect(game.game_players[0].active_turn).to be(true)
    expect(game.game_players[1].active_turn).to be(false)
  end

  it 'target will return false if game already complete' do
    game = Game.create
    game_player_1 = game.get_player(game.computer_game_player_id)
    game_player_2 = game.get_player(game.human_game_player_id)
    ship_type = ShipType.create(name: 'a', size: 2)
    Ship.create_on_grid(game_player_1, ship_type, ['B1', 'B2'])
    ship = Ship.create_on_grid(game_player_2, ship_type, ['C1', 'D1'])

    game.game_players[1].ships.first.cells.update(targeted: true)
    expect(game.result).to eq(game_player_1)
    expect(game.target('G6')).to be(false)
    expect(game.game_players[0].grid.find_cell_by_coord('G6').targeted).to be(false)
  end

  it 'target will return false if player already targeted in their turn' do
    game = Game.create
    game_player_1 = game.get_player(game.computer_game_player_id)
    game_player_2 = game.get_player(game.human_game_player_id)
    ship_type = ShipType.create(name: 'a', size: 2)
    Ship.create_on_grid(game_player_1, ship_type, ['B1', 'B2'])
    ship = Ship.create_on_grid(game_player_2, ship_type, ['C1', 'D1'])

    expect(game.target('D8')).to be(true)
    expect(game.target('C8')).to be(false)
    expect(game.target('B8')).to be(false)
    expect(game.game_players[0].grid.find_cell_by_coord('D8').targeted).to be(true)
    expect(game.game_players[0].grid.find_cell_by_coord('C8').targeted).to be(false)
    expect(game.game_players[0].grid.find_cell_by_coord('B8').targeted).to be(false)
  end

  it 'target will return false if player already targeted cell' do
    game = Game.create
    game_player_1 = game.get_player(game.computer_game_player_id)
    game_player_2 = game.get_player(game.human_game_player_id)
    ship_type = ShipType.create(name: 'a', size: 2)
    Ship.create_on_grid(game_player_1, ship_type, ['B1', 'B2'])
    ship = Ship.create_on_grid(game_player_2, ship_type, ['C1', 'D1'])

    game.game_players[0].grid.find_cell_by_coord('D8').update(targeted: true)
    expect(game.target('D8')).to be(false)
    expect(game.game_players[0].grid.find_cell_by_coord('D8').targeted).to be(true)
  end

  it 'target will return false if setup not complete' do
    game = Game.create
    game_player_1 = game.get_player(game.computer_game_player_id)
    game_player_2 = game.get_player(game.human_game_player_id)

    expect(game.target('A8')).to be(false)
    expect(game.game_players[0].grid.find_cell_by_coord('A8').targeted).to be(false)
  end

  it 'change_turn will reset the turn targeted flag' do
    game = Game.create
    game_player_1 = game.get_player(game.computer_game_player_id)
    game_player_2 = game.get_player(game.human_game_player_id)
    ship_type = ShipType.create(name: 'a', size: 2)
    Ship.create_on_grid(game_player_1, ship_type, ['B1', 'B2'])
    ship = Ship.create_on_grid(game_player_2, ship_type, ['C1', 'D1'])

    expect(game.target('A8')).to be(true)
    expect(game.change_turn).to be(true)
    expect(game.target('F2')).to be(true)
    expect(game.change_turn).to be(true)
    expect(game.target('C1')).to be(true)
  end

  it 'change_turn return false and not rotate turn if no turn target yet' do
    game = Game.create
    game_player_1 = game.get_player(game.computer_game_player_id)
    game_player_2 = game.get_player(game.human_game_player_id)

    expect(game_player_2.active_turn).to be(true)
    expect(game_player_1.active_turn).to be(false)
    expect(game.change_turn).to be(false)
    expect(game_player_2.active_turn).to be(true)
    expect(game_player_1.active_turn).to be(false)
  end
end

# TODO
# AI, random ship positing and AI targeting
