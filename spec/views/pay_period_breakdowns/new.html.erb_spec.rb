require 'rails_helper'

RSpec.describe "pay_period_breakdowns/new", type: :view do
  before(:each) do
    assign(:pay_period_breakdown, PayPeriodBreakdown.new(
      paycheck_amount: 1,
      pay_frequency: 1,
      pay_date: Date.today,
      credit_card_allocation_pct: 75,
      individual_allocation_pct: 25
    ))
  end

  it "renders new pay_period_breakdown form" do
    render

    assert_select "form[action=?][method=?]", pay_period_breakdowns_path, "post" do

      assert_select "input[name=?]", "pay_period_breakdown[paycheck_amount]"

      assert_select "input[name=?]", "pay_period_breakdown[pay_frequency]"

      assert_select "input[name=?]", "pay_period_breakdown[credit_card_allocation_pct]"

      assert_select "input[name=?]", "pay_period_breakdown[individual_allocation_pct]"
    end
  end
end
