class AddDefaultValuesToCrush < ActiveRecord::Migration
  def change
    change_column :crushes, :num_tags, :integer, default: 0
    change_column :crushes, :quotient, :float, default: 0.0
  end
end
