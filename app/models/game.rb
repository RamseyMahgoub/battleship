class Game < ApplicationRecord
  has_many :game_players

  def self.create
    game = super
    game.game_players.create
    game.game_players.create(
      :active_turn => true,
      :human_player => true,
    )

    game
  end

  def human_game_player_id
    game_players.find { |game_player| game_player.human_player }.id
  end

  def get_player(id)
    game_players.find { |game_player| game_player.id = id }
  end
end
