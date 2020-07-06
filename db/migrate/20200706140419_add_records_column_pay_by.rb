class AddRecordsColumnPayBy < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :pay_by, :string
  end
end
