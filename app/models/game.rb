class Game < ApplicationRecord
  has_many :game_players

  def self.create
    game = super
    game.game_players.create_computer_player
    game.game_players.create_human_player

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
end
