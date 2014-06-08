class AddLastTagTimeToCrushes < ActiveRecord::Migration
  def change
    add_column :crushes, :last_tag_time, :datetime
  end
end
