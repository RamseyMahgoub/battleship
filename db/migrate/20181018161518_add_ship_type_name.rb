class AddShipTypeName < ActiveRecord::Migration[5.2]
  def change
    add_column :ship_types, :name, :string
  end
end
