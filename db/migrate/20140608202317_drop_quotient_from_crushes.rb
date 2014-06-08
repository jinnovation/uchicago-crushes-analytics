class DropQuotientFromCrushes < ActiveRecord::Migration
  def change
    remove_column :crushes, :quotient, :float
  end
end
