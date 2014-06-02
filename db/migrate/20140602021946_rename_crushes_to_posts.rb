class RenameCrushesToPosts < ActiveRecord::Migration
  def change
    rename_table :crushes, :posts
  end
end
