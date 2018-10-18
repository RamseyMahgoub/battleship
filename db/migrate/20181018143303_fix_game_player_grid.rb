class FixGamePlayerGrid < ActiveRecord::Migration[5.2]
  def change
    remove_column :game_players, :grid_id
    remove_column :games, :game_player1
    remove_column :games, :game_player2
    add_reference :game_players, :game
    add_reference :grids, :game_player
  end
end
