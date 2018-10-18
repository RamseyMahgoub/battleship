class Gameplayers < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :game, :game_player, column: :game_player1
    add_foreign_key :game, :game_player, column: :game_player2
  end
end
