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

    before do
      allow(ShipType).to receive(:all).and_return([ship_a, ship_b])
      allow(ShipType).to receive(:find) do |id|
        [ship_a, ship_b].find { |ship| ship.id == id }
      end
    end

    it 'creates ships for the given valid array of ships' do
      ships = [{
        ship_type_id: ship_a.id,
        coords: ['A1', 'A2'],
      }, {
        ship_type_id: ship_b.id,
        coords: ['H10', 'I10', 'J10'],
      }]
      expect(game_player.create_ships(ships)).to be(true)

      ships.each_with_index do |ship, index|
        actual = game.game_players[0].ships[index]
        expect(actual.ship_type_id).to be(ship.fetch(:ship_type_id))
        expect(actual.ship_cells.size).to be(ship.fetch(:coords).size)
      end
    end

    it 'creates ships for the given valid array of ships (array not ordered and contains double digits)' do
      ships = [{
        ship_type_id: ship_a.id,
        coords: ['E1', 'F1'],
      }, {
        ship_type_id: ship_b.id,
        coords: ['A10', 'A8', 'A9'],
      }]
      expect(game_player.create_ships(ships)).to be(true)

      ships.each_with_index do |ship, index|
        actual = game.game_players[0].ships[index]
        expect(actual.ship_type_id).to be(ship.fetch(:ship_type_id))
        expect(actual.ship_cells.size).to be(ship.fetch(:coords).size)
      end
    end

    it 'create_ships randomly places ships if no config supplied' do
      expect(game_player.create_ships).to be(true)
    end

    context 'validates' do
      it 'when no ships exist' do
        ships = []
        expect(game_player.create_ships(ships)).to be(false)
      end

      it 'when not all ships exist' do
        ships = [{
          ship_type_id: ship_a.id,
          coords: ['A1', 'A2'],
        }]
        expect(game_player.create_ships(ships)).to be(false)
      end

      it 'when not all ship types are supplied' do
        ships = [{
          ship_type_id: ship_a.id,
          coords: ['A1', 'A2'],
        }, {
          ship_type_id: ship_a.id,
          coords: ['A1', 'A2'],
        }]
        expect(game_player.create_ships(ships)).to be(false)
      end

      it 'when ship sizes are not valid' do
        ships = [{
          ship_type_id: ship_a.id,
          coords: ['A1', 'A2'],
        }, {
          ship_type_id: ship_b.id,
          coords: ['E4', 'E5'],
        }]

        expect(game_player.create_ships(ships)).to be(false)
      end

      it 'when ship orientation is not valid - gap' do
        ships = [{
          ship_type_id: ship_a.id,
          coords: ['A1', 'A2'],
        }, {
          ship_type_id: ship_b.id,
          coords: ['E4', 'E5', 'D6'],
        }]

        expect(game_player.create_ships(ships)).to be(false)
      end

      it 'when ship orientation is not valid - not straight' do
        ships = [{
          ship_type_id: ship_a.id,
          coords: ['A1', 'A2'],
        }, {
          ship_type_id: ship_b.id,
          coords: ['E5', 'E4', 'F4'],
        }]

        expect(game_player.create_ships(ships)).to be(false)
      end

      it 'when ship is not within grid cells - x max' do
        ships = [{
          ship_type_id: ship_a.id,
          coords: ['J1', 'K1'],
        }, {
          ship_type_id: ship_b.id,
          coords: ['E4', 'E5', 'E6'],
        }]

        expect(game_player.create_ships(ships)).to be(false)
      end

      it 'when ship is not within grid cells - x min' do
        ships = [{
          ship_type_id: ship_a.id,
          coords: ['?1', 'A1'],
        }, {
          ship_type_id: ship_b.id,
          coords: ['E4', 'E5', 'E6'],
        }]

        expect(game_player.create_ships(ships)).to be(false)
      end

      it 'when ship is not within grid cells - y max' do
        ships = [{
          ship_type_id: ship_a.id,
          coords: ['A10', 'A11'],
        }, {
          ship_type_id: ship_b.id,
          coords: ['E4', 'E5', 'E6'],
        }]

        expect(game_player.create_ships(ships)).to be(false)
      end

      it 'when ship is not within grid cells - y min' do
        ships = [{
          ship_type_id: ship_a.id,
          coords: ['A0', 'A1'],
        }, {
          ship_type_id: ship_b.id,
          coords: ['E4', 'E5', 'E6'],
        }]

        expect(game_player.create_ships(ships)).to be(false)
      end

      it 'when ships are overlapping' do
        ships = [{
          ship_type_id: ship_a.id,
          coords: ['A1', 'A2'],
        }, {
          ship_type_id: ship_b.id,
          coords: ['A2', 'B2', 'C2'],
        }]

        expect(game_player.create_ships(ships)).to be(false)
      end

      it 'doesnt make any ships in the grid' do
        ships = []
        game_player.create_ships(ships)

        expect(game_player.ships.size).to be(0)
      end
    end
  end

  it 'target given a coord, sets cell to be targeted' do
    game_player = GamePlayer.create_human_player(game)
    game_player.receive_target('G5')
    expect(game_player.grid.find_cell_by_coord('G5').targeted).to be(true)
  end
end
