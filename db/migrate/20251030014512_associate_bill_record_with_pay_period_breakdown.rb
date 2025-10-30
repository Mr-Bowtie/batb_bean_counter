class AssociateBillRecordWithPayPeriodBreakdown < ActiveRecord::Migration[7.2]
  def change
    add_column :bill_records, :pay_period_breakdown_id, :integer
  end
end
