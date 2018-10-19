class AddHumanPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :game_players, :human_player, :boolean, default:false
  end
end
