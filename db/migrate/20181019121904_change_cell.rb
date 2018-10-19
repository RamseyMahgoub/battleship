class ChangeCell < ActiveRecord::Migration[5.2]
  def change
    remove_column :cells, :coord
    add_column :cells, :x, :integer
    add_column :cells, :y, :integer
  end
end
