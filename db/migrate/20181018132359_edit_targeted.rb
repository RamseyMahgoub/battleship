class EditTargeted < ActiveRecord::Migration[5.2]
  def change
    change_column :cells , :targeted, :boolean, default:false
  end
end
