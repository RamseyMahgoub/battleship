class MoveActiveTurn < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :active_turn
    add_column :game_players, :active_turn, :boolean
  end
end
