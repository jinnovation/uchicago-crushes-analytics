class CreateCrushes < ActiveRecord::Migration
  def change
    create_table :crushes do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
  end
end
