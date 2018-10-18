class CreateGrids < ActiveRecord::Migration[5.2]
  def change
    create_table :grids do |t|
      t.references :cell, foreign_key: true

      t.timestamps
    end
  end
end
