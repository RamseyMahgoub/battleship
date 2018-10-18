class CreateShips < ActiveRecord::Migration[5.2]
  def change
    create_table :ships do |t|
      t.references :game_player, foreign_key: true
      t.references :ship_type, foreign_key: true

      t.timestamps
    end
  end
end
