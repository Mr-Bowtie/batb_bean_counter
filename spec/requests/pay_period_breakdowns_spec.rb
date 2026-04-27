require "rails_helper"

RSpec.describe "/pay_period_breakdowns", type: :request do
  let(:user) { User.create!(email: "pay-periods@example.com", password: "password123") }

  before do
    sign_in user
  end

  describe "POST /create" do
    it "creates a pay period with custom allocations" do
      expect do
        post pay_period_breakdowns_url, params: {
          pay_period_breakdown: {
            paycheck_amount: "5000.00",
            pay_date: Date.new(2025, 1, 1),
            pay_frequency: 14,
            pay_period_allocations_attributes: {
              "0" => { label: "Debt", percentage: 50 },
              "1" => { label: "Savings", percentage: 30 },
              "2" => { label: "Fun", percentage: 20 }
            }
          }
        }
      end.to change(PayPeriodBreakdown, :count).by(1)

      breakdown = PayPeriodBreakdown.last
      expect(response).to redirect_to(pay_period_breakdown_url(breakdown))
      expect(breakdown.pay_period_allocations.pluck(:label, :percentage)).to contain_exactly(
        ["Debt", 50],
        ["Savings", 30],
        ["Fun", 20]
      )
    end
  end

  describe "PATCH /update" do
    let!(:pay_period_breakdown) do
      PayPeriodBreakdown.create!(
        paycheck_amount: 5_000_00,
        pay_date: Date.new(2025, 1, 1),
        pay_frequency: 14
      )
    end

    it "updates, removes, and adds allocations in one request" do
      first_allocation, second_allocation = pay_period_breakdown.pay_period_allocations.order(:id)

      patch pay_period_breakdown_url(pay_period_breakdown), params: {
        pay_period_breakdown: {
          pay_period_allocations_attributes: {
            "0" => { id: first_allocation.id, label: "Debt", percentage: 60 },
            "1" => { id: second_allocation.id, _destroy: "1" },
            "2" => { label: "Savings", percentage: 40 }
          }
        }
      }

      expect(response).to redirect_to(pay_period_breakdown_url(pay_period_breakdown))
      expect(pay_period_breakdown.reload.pay_period_allocations.pluck(:label, :percentage)).to contain_exactly(
        ["Debt", 60],
        ["Savings", 40]
      )
    end
  end
end
