class AddPicUrlsToUser < ActiveRecord::Migration
  def change
    add_column :users, :pic_url_small, :text
    add_column :users, :pic_url_medium, :text
    add_column :users, :pic_url_large, :text
  end
end
