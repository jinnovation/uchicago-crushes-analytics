class AddFbIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :fb_id, :text
  end
end
