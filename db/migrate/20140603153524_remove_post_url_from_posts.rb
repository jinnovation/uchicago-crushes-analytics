class RemovePostUrlFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :post_url, :text
  end
end
