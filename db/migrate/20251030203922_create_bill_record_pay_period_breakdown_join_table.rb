class CreateBillRecordPayPeriodBreakdownJoinTable < ActiveRecord::Migration[7.2]
  def change
    create_table :bill_records_pay_period_breakdowns, id: false do |t|
      t.belongs_to :bill_record
      t.belongs_to :pay_period_breakdown
    end
  end
end
