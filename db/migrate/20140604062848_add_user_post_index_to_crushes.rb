class AddUserPostIndexToCrushes < ActiveRecord::Migration
  def change
    add_index :crushes, [:user_id, :post_id], unique: true
  end
end
