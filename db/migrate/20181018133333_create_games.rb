class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :game_player1
      t.integer :game_player2
      t.integer :activeturn

      t.timestamps
    end
  end
end
