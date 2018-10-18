class Fk2 < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :games, :game_players, column: :game_player1, primary_key: "id"
  end
end
