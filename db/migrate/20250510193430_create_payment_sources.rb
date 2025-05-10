class CreatePaymentSources < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_sources do |t|
      t.string :name
      t.integer :payment_type

      t.timestamps
    end
  end
end
