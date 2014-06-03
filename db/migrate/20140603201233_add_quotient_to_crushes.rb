class AddQuotientToCrushes < ActiveRecord::Migration
  def change
    add_column :crushes, :quotient, :float
  end
end
