class ChangeRecordTableName < ActiveRecord::Migration[5.2]
  def change
    rename_table :records, :purchase_records
  end
end
