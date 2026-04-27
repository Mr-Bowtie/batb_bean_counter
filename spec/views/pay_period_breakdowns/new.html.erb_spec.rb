require 'rails_helper'

RSpec.describe "pay_period_breakdowns/new", type: :view do
  before(:each) do
    pay_period_breakdown = PayPeriodBreakdown.new(
      paycheck_amount: 1,
      pay_frequency: 1,
      pay_date: Date.today
    )
    pay_period_breakdown.build_default_allocations

    assign(:pay_period_breakdown, pay_period_breakdown)
  end

  it "renders new pay_period_breakdown form" do
    render

    assert_select "form[action=?][method=?]", pay_period_breakdowns_path, "post" do

      assert_select "input[name=?]", "pay_period_breakdown[paycheck_amount]"

      assert_select "input[name=?]", "pay_period_breakdown[pay_frequency]"

      assert_select "input[name=?]", "pay_period_breakdown[pay_period_allocations_attributes][0][label]"
      assert_select "input[name=?]", "pay_period_breakdown[pay_period_allocations_attributes][0][percentage]"
      assert_select "input[name=?]", "pay_period_breakdown[pay_period_allocations_attributes][1][label]"
      assert_select "input[name=?]", "pay_period_breakdown[pay_period_allocations_attributes][1][percentage]"
    end
  end
end
