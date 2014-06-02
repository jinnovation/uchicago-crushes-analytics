class AddFbCreatedTimeToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :fb_created_time, :datetime
  end
end
