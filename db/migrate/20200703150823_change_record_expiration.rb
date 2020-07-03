class ChangeRecordExpiration < ActiveRecord::Migration[5.2]
  def up
    change_column :records, :expired_at, :datetime
  end
  def down
    change_column :records, :expired_at, :string
  end
end
