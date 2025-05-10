class CreateBillRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :bill_records do |t|
      t.integer :billId
      t.boolean :paid
      t.date :date
      t.text :message

      t.timestamps
    end
  end
end
