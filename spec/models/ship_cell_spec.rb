require 'rails_helper'

RSpec.describe ShipCell, type: :model do
  let(:game) do
    game = Game.new
    game.save
    game
  end
  let(:ship_type) { ShipType.create(name: 'a', size: 3) }
  let(:game_player) { GamePlayer.create(game, true, false) }

  context 'piece, piece type for horizontal ships' do
    let(:ship) { Ship.create_on_grid(game_player, ship_type, ['A1', 'B1', 'C1']) }

    it 'returns the top piece as south' do
      expect(ship.ship_cells[0].piece).to be(:south)
    end

    it 'returns the middle piece as vertical' do
      expect(ship.ship_cells[1].piece).to be(:vertical)
    end

    it 'returns the bottom piece as north' do
      expect(ship.ship_cells[2].piece).to be(:north)
    end
  end

  context 'piece, piece type for vertical ships' do
    let(:ship) { Ship.create_on_grid(game_player, ship_type, ['B1', 'B2', 'B3']) }

    it 'returns the left piece as east' do
      expect(ship.ship_cells[0].piece).to be(:east)
    end

    it 'returns the middle piece as horizontal' do
      expect(ship.ship_cells[1].piece).to be(:horizontal)
    end

    it 'returns the right piece as west' do
      expect(ship.ship_cells[2].piece).to be(:west)
    end
  end
end
