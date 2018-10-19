class GamePlayer < ApplicationRecord
  belongs_to :game
  has_one :grid

  def self.create(game, active_turn, human_player)
    game_player = super({
      game: game,
      active_turn: active_turn,
      human_player: human_player,
    })

    game_player.grid = Grid.create(game_player)
    game_player
  end

  def self.create_human_player(game)
    game_player = GamePlayer.create(game, true, true)
    game_player
  end

  def self.create_computer_player(game)
    game_player = GamePlayer.create(game, false, false)
    game_player
  end

  def create_ships(ship_configs)
    return false if !ships_valid?(ship_configs)
  end

  private

  def ships_valid?(ship_configs)
    ship_configs.all? do |ship_config|
      return false if !ship_size_valid?(ship_config)
      return false if !ship_orientation_valid?(ship_config)

    end
  end

  def ship_size_valid?(ship_config)
    ship_type = ShipTypes.find(ship_config.ship_type_id)
    ship_type.size == ship_config.coords.uniq.size
  end

  def ship_orientation_valid?(ship_config)
    ship_config.coords.map { |coord| Cell.from_coord(coord) }
  end
end
