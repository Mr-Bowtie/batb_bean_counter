class AddAmountToBillRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :bill_records, :amount, :integer

    reversible do |dir|
      dir.up do
        execute <<~SQL
          UPDATE bill_records
          SET amount = bills.amount
          FROM bills
          WHERE bill_records.bill_id = bills.id
        SQL
      end
    end

    change_column_null :bill_records, :amount, false
  end
end
