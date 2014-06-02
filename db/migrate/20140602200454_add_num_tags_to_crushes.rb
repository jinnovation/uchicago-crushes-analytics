class AddNumTagsToCrushes < ActiveRecord::Migration
  def change
    add_column :crushes, :num_tags, :integer
  end
end
