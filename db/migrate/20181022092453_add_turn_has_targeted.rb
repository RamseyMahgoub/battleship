class AddTurnHasTargeted < ActiveRecord::Migration[5.2]
  def change
    add_column :game_players, :turn_has_targeted, :boolean, default: false
  end
end
