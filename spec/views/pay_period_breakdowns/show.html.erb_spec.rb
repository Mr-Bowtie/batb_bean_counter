require 'rails_helper'

RSpec.describe "pay_period_breakdowns/show", type: :view do
  before(:each) do
    assign(:pay_period_breakdown, PayPeriodBreakdown.create!(
      paycheck_amount: 2,
      pay_frequency: 3,
      pay_date: Date.today
    ))
    assign(:bill_records, [])
    assign(:calculation, {
      bill_amount_remaining: 0,
      leftover_funds: 0,
      credit_card_funds: 0,
      individual_total_funds: 0,
      individual_funds: 0,
      credit_card_allocation_pct: 75,
      individual_allocation_pct: 25
    })
    assign(:remaining_bill_total_cents, 0)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
