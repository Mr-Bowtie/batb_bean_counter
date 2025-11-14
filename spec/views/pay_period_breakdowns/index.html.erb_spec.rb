require 'rails_helper'

RSpec.describe "pay_period_breakdowns/index", type: :view do
  before(:each) do
    pay_periods = [
      PayPeriodBreakdown.create!(
        paycheck_amount: 2,
        pay_frequency: 3,
        pay_date: Date.today
      ),
      PayPeriodBreakdown.create!(
        paycheck_amount: 2,
        pay_frequency: 3,
        pay_date: Date.today
      )
    ]

    assign(:pay_period_breakdowns, PayPeriodBreakdown.where(id: pay_periods.map(&:id)))
  end

  it "renders a list of pay_period_breakdowns" do
    render
    assert_select "div.pay-period-breakdown", count: 2
  end
end
