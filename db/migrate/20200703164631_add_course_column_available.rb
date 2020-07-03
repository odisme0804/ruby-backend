class AddCourseColumnAvailable < ActiveRecord::Migration[5.2]
  def up
    add_column :courses, :available, :boolean
  end

  def down
    remove_column :courses, :available
  end
end
