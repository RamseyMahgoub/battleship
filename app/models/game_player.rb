class GamePlayer < ApplicationRecord
  belongs_to :game
  has_one :grid
  has_many :ships

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

  # Refactor: game_player is doing alot of ship validation
  def create_ships(ship_configs)
    return false if !ships_valid?(ship_configs)
    ship_configs.each { |ship_config| create_ship(ship_config) }
    return true
  end

  def receive_target(coord)
    target = grid.find_cell_by_coord(coord)

    return false if turn_has_targeted
    return false if target.targeted

    target.update(targeted: true)
    update(turn_has_targeted: true)

    true
  end

  private

  def create_ship(ship_config)
    Ship.create_on_grid(
      self,
      ShipType.find(ship_config.fetch(:ship_type_id)),
      ship_config.fetch(:coords),
    )
  end

  def ships_valid?(ship_configs)
    return false if !ship_count_valid?(ship_configs)
    return false if !ship_types_valid?(ship_configs)
    return false if !ship_uniq_cell_valid?(ship_configs)

    return false if !ship_configs.all? do |ship_config|
      return false if !ship_size_valid?(ship_config)
      return false if !ship_limits_valid?(ship_config)
      return false if !ship_orientation_valid?(ship_config)
      true
    end

    true
  end

  def ship_count_valid?(ship_configs)
    ShipType.all.size == ship_configs.size
  end

  def ship_types_valid?(ship_configs)
    ShipType.all.all? do |ship_type|
      ship_configs.any? do |ship_config|
        ship_config.fetch(:ship_type_id) == ship_type.id
      end
    end
  end

  def ship_uniq_cell_valid?(ship_configs)
    all_coords = ship_configs.flat_map { |ship_config| ship_config.fetch(:coords) }
    all_coords.size == all_coords.uniq.size
  end

  def ship_size_valid?(ship_config)
    ship_type = ShipType.find(ship_config.fetch(:ship_type_id))
    ship_type.size == ship_config.fetch(:coords).uniq.size
  end

  def ship_limits_valid?(ship_config)
    cells = ship_config.fetch(:coords).map { |coord| Cell.from_coord(coord) }

    cells.all? do |cell|
      cell.x.between?(1, grid.size) && cell.y.between?(1, grid.size)
    end
  end

  def ship_orientation_valid?(ship_config)
    cells = ship_config.fetch(:coords)
      .sort
      .map { |coord| Cell.from_coord(coord) }

    connected_x = cells.each_cons(2).all? { |a, b| a.connected_through_x?(b) }
    connected_y = cells.each_cons(2).all? { |a, b| a.connected_through_y?(b) }

    connected_x || connected_y
  end
end
