class AddBillTotalToPayPeriodBreakdown < ActiveRecord::Migration[7.2]
  def change
    add_column :pay_period_breakdowns, :bill_total, :integer
  end
end
