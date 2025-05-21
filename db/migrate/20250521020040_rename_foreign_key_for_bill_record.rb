class RenameForeignKeyForBillRecord < ActiveRecord::Migration[7.2]
  def change
    rename_column(:bill_records, :billId, :bill_id)
  end
end
