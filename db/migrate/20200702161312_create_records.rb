class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.integer :user_id
      t.integer :course_id
      t.string :expired_at

      t.timestamps
    end
  end
end
