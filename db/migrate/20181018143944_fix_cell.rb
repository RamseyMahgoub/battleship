class FixCell < ActiveRecord::Migration[5.2]
  def change
    remove_column :grids, :cell_id
    add_reference :cells, :grid
  end
end
