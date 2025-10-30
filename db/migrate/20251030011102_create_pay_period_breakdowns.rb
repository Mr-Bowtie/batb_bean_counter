class CreatePayPeriodBreakdowns < ActiveRecord::Migration[7.2]
  def change
    create_table :pay_period_breakdowns do |t|
      t.integer :paycheck_amount
      t.date :pay_date
      t.date :next_pay_date
      t.integer :pay_frequency
      t.timestamps
    end
  end
end
