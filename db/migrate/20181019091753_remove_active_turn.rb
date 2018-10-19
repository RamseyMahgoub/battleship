class RemoveActiveTurn < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :activeturn
  end
end
