class ChangeStringToTextCrushes < ActiveRecord::Migration
  def change
        change_column :crushes, :content, :text
  end
end
