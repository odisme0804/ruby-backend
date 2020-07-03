class DropTransactionTable < ActiveRecord::Migration[5.2]
  def up
    drop_table :transactions
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
