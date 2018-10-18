class CreateShipTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :ship_types do |t|
      t.integer :size

      t.timestamps
    end
  end
end
