require 'rails_helper'

RSpec.describe "pay_period_breakdowns/index", type: :view do
  before(:each) do
    assign(:pay_period_breakdowns, [
      PayPeriodBreakdown.create!(
        paycheck_amount: 2,
        pay_frequency: 3
      ),
      PayPeriodBreakdown.create!(
        paycheck_amount: 2,
        pay_frequency: 3
      )
    ])
  end

  it "renders a list of pay_period_breakdowns" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
  end
end
