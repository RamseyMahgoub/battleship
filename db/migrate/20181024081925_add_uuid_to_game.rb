class AddUuidToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :uuid, :string
  end
end
