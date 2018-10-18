class CreateGamePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :game_players do |t|
      t.references :grid, foreign_key: true

      t.timestamps
    end
  end
end
