class ChangeCourseColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :courses, :type, :category
  end
end
