class AddLastTurnToGamePlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :game_players, :last_turn_cell_id, :integer
  end
end
