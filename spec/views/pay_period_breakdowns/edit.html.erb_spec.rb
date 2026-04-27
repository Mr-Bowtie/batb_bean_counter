require 'rails_helper'

RSpec.describe "pay_period_breakdowns/edit", type: :view do
  let(:pay_period_breakdown) {
    PayPeriodBreakdown.create!(
      paycheck_amount: 1_000_00,
      pay_frequency: 14,
      pay_date: Date.today
    )
  }

  before(:each) do
    assign(:pay_period_breakdown, pay_period_breakdown)
  end

  it "renders the edit pay_period_breakdown form" do
    render

    assert_select "form[action=?][method=?]", pay_period_breakdown_path(pay_period_breakdown), "post" do

      assert_select "input[name=?]", "pay_period_breakdown[paycheck_amount]"

      assert_select "input[name=?]", "pay_period_breakdown[pay_frequency]"

      assert_select "input[name=?]", "pay_period_breakdown[pay_period_allocations_attributes][0][label]"
      assert_select "input[name=?]", "pay_period_breakdown[pay_period_allocations_attributes][0][percentage]"
      assert_select "input[name=?]", "pay_period_breakdown[pay_period_allocations_attributes][1][label]"
      assert_select "input[name=?]", "pay_period_breakdown[pay_period_allocations_attributes][1][percentage]"
    end
  end
end
