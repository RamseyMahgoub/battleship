class CreateCells < ActiveRecord::Migration[5.2]
  def change
    create_table :cells do |t|
      t.string :coord
      t.boolean :targeted
      t.timestamps
    end
  end
end
