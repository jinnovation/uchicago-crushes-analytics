class AddPostUrlToCrushes < ActiveRecord::Migration
  def change
    add_column :crushes, :post_url, :text
  end
end
