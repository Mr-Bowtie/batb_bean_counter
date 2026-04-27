require 'rails_helper'

RSpec.describe "pay_period_breakdowns/show", type: :view do
  before(:each) do
    assign(:pay_period_breakdown, PayPeriodBreakdown.create!(
      paycheck_amount: 2,
      pay_frequency: 3,
      pay_date: Date.today
    ))
    assign(:bill_records, [])
    assign(:new_bill_record, BillRecord.new(date: Date.today))
    assign(:calculation, {
      bill_amount_remaining: 0,
      leftover_funds: 0,
      allocations: [
        { label: "Leftover Allocation", percentage: 75, amount: 0 },
        { label: "Personal Allocation", percentage: 25, amount: 0 }
      ]
    })
    assign(:remaining_bill_total_cents, 0)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
