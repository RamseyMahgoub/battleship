class AddActiveTurnDefault < ActiveRecord::Migration[5.2]
  def change
    change_column :game_players, :active_turn, :boolean, default:false
  end
end
