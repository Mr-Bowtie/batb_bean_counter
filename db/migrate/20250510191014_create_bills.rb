class CreateBills < ActiveRecord::Migration[7.2]
  def change
    create_table :bills do |t|
      t.string :name
      t.integer :date_number
      t.integer :amount
      t.integer :payment_source
      t.text :tags, array: true, default: []

      t.timestamps
    end
  end
end
