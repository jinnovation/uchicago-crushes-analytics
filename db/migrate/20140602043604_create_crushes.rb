class CreateCrushes < ActiveRecord::Migration
  def change
    create_table :crushes do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
  end
end
