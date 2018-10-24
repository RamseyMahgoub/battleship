class Game < ApplicationRecord
  has_many :game_players

  def self.create
    game = super(uuid: SecureRandom.urlsafe_base64(16))
    game.game_players.create_computer_player(game)
    game.game_players.create_human_player(game)

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

  # TODO: proper AI coord picking
  def target(coord = next_ai_coord)
    return false if game_players.any? { |game_player| game_player.ships.size == 0 }
    return false if result
    return get_receive_turn_player.receive_target(coord)
  end

  # Refactor: game should not be setting on game_player
  def change_turn
    active = get_active_turn_player
    receiver = get_receive_turn_player

    return false if !receiver.turn_has_targeted

    active.update(active_turn: false)
    receiver.update(active_turn: true, turn_has_targeted: false)

    true
  end

  private

  def next_ai_coord
    get_player(human_game_player_id).grid.cells.find { |cell| !cell.targeted }.coord
  end

  def get_active_turn_player
    game_players.find(&:active_turn)
  end

  def get_receive_turn_player
    game_players.find { |game_player| !game_player.active_turn }
  end
end
