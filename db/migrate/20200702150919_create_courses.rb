class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :topic
      t.string :description
      t.integer :price
      t.string :currency
      t.string :type
      t.string :url
      t.integer :expiration

      t.timestamps
    end
  end
end
