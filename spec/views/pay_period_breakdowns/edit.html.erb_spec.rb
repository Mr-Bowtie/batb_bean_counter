require 'rails_helper'

RSpec.describe "pay_period_breakdowns/edit", type: :view do
  let(:pay_period_breakdown) {
    PayPeriodBreakdown.create!(
      paycheck_amount: 1,
      pay_frequency: 1
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
    end
  end
end
