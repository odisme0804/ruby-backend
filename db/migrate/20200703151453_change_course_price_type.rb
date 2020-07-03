class ChangeCoursePriceType < ActiveRecord::Migration[5.2]
  def up
    change_column :courses, :price, :float
  end
  def down
    change_column :courses, :price, :integer
  end
end
