class Game < ApplicationRecord
  has_many :game_players

  def self.create(size = Grid.default_size)
    game = super(uuid: SecureRandom.urlsafe_base64(16))
    game.game_players.create_computer_player(game, size)
    game.game_players.create_human_player(game, size)

    game
  end

  def human_game_player_id
    game_players.find { |game_player| game_player.human_player }.id
  end

  def computer_game_player_id
    game_players.find { |game_player| !game_player.human_player }.id
  end

  def get_player(id)
    game_players.find(id)
  end

  # Refactor: game should not reach into ships
  def result
    loser = game_players.find do |game_player|
      game_player.ships.all?(&:sunk?) && game_player.ships.size > 0
    end

    if loser
      return game_players.find { |game_player| game_player.id != loser.id }
    end
  end

  def target(coord = ai_coord_options.sample)
    return false if game_players.any? { |game_player| game_player.ships.size == 0 }
    return false if result
    return get_receive_turn_player.receive_target(coord)
  end

  # Refactor: game should not be setting on game_player
  def change_turn
    active = get_active_turn_player
    receiver = get_receive_turn_player

    return false if !can_change_turn?

    active.update(active_turn: false)
    receiver.update(active_turn: true, turn_has_targeted: false)

    true
  end

  def can_change_turn?
    get_receive_turn_player.turn_has_targeted
  end

  def ai_coord_options
    grid = get_player(human_game_player_id).grid
    current_hit_cell = grid.cells.find { |cell| cell.state == :hit }

    if current_hit_cell
      return aligned_connecting_options(current_hit_cell)
    else
      return random_options
    end
  end

  def setup?
    game_players.all? do |game_player|
      game_player.ships.size == ShipType.all.size
    end
  end

  private

  def aligned_connecting_options(cell)
    grid = get_player(human_game_player_id).grid
    options = random_connecting_options(cell, :hit)
    aligned_options = []
    existing_hits = [cell]

    connecting_cell = options
      .map { |coord| grid.find_cell_by_coord(coord) }
      .sample

    return random_connecting_options(cell) if !connecting_cell

    transform = cell.connected_through_x?(connecting_cell) ? { x: 1, y: 0 } : { x: 0, y: 1 }
    ends_found = 0
    current_cell = cell

    while ends_found < 2
      current_cell = Cell.new({
        x: current_cell.x + transform.fetch(:x),
        y: current_cell.y + transform.fetch(:y),
      })

      valid = current_cell.x.between?(1, grid.size) && current_cell.y.between?(1, grid.size)

      if valid
        current_cell_state = grid.find_cell_by_coord(current_cell.coord).state
      end

      if !valid || current_cell_state == :sunk || current_cell_state == :miss
        transform = { x: -transform.fetch(:x), y: -transform.fetch(:y) }
        ends_found += 1
      elsif current_cell_state == :empty
        aligned_options.push(current_cell.coord)
        transform = { x: -transform.fetch(:x), y: -transform.fetch(:y) }
        ends_found += 1
      elsif current_cell_state == :hit
        existing_hits.push(current_cell)
      end
    end

    if aligned_options.size == 0
      fallback_options = []
      counter = 0

      while fallback_options.size == 0 && counter < existing_hits.size
        fallback_options = random_connecting_options(existing_hits[counter])
        counter += 1
      end

      return random_options if fallback_options.size == 0
      return fallback_options
    end

    aligned_options
  end

  def random_connecting_options(cell, search_for_state = :empty)
    grid = get_player(human_game_player_id).grid

    next_cell_options = []
    next_cell_options.push({ x: -1, y: 0 }) if cell.x.between?(2, grid.size)
    next_cell_options.push({ x: 1, y: 0 }) if cell.x.between?(1, grid.size - 1)
    next_cell_options.push({ x: 0, y: -1 }) if cell.y.between?(2, grid.size)
    next_cell_options.push({ x: 0, y: 1 }) if cell.y.between?(1, grid.size - 1)

    next_cell_options
      .map do |transform|
        Cell.new({
          x: cell.x + transform.fetch(:x),
          y: cell.y + transform.fetch(:y),
        }).coord
      end
      .select do |coord|
        grid.find_cell_by_coord(coord).state == search_for_state
      end
  end

  def random_options
    grid = get_player(human_game_player_id).grid
    grid.cells
      .select { |cell| cell.state == :empty }
      .map(&:coord)
  end

  def get_active_turn_player
    game_players.find(&:active_turn)
  end

  def get_receive_turn_player
    game_players.find { |game_player| !game_player.active_turn }
  end
end
