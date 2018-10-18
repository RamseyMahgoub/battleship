class CreateShipCells < ActiveRecord::Migration[5.2]
  def change
    create_table :ship_cells do |t|
      t.references :ship, foreign_key: true
      t.references :cell, foreign_key: true

      t.timestamps
    end
  end
end
