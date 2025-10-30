require 'rails_helper'

RSpec.describe "pay_period_breakdowns/show", type: :view do
  before(:each) do
    assign(:pay_period_breakdown, PayPeriodBreakdown.create!(
      paycheck_amount: 2,
      pay_frequency: 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
