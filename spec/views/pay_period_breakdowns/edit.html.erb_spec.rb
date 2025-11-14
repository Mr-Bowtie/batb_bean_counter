require 'rails_helper'

RSpec.describe "pay_period_breakdowns/edit", type: :view do
  let(:pay_period_breakdown) {
    PayPeriodBreakdown.create!(
      paycheck_amount: 1_000_00,
      pay_frequency: 14,
      pay_date: Date.today,
      credit_card_allocation_pct: 75,
      individual_allocation_pct: 25
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

      assert_select "input[name=?]", "pay_period_breakdown[credit_card_allocation_pct]"

      assert_select "input[name=?]", "pay_period_breakdown[individual_allocation_pct]"
    end
  end
end
