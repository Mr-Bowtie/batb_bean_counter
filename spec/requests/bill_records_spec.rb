require "rails_helper"

RSpec.describe "/bill_records", type: :request do
  describe "PATCH /update" do
    let(:user) { User.create!(email: "tester@example.com", password: "password123") }
    let(:payment_source) { PaymentSource.create!(name: "Checking", payment_type: :checking_account) }
    let(:bill) do
      Bill.create!(name: "Rent", amount: 1_500_00, date_number: 5, payment_source:, show_each_paycheck: false)
    end
    let!(:bill_record) { BillRecord.create!(bill:, date: Date.new(2025, 1, 5), amount: bill.amount) }
    let!(:pay_period_breakdown) do
      PayPeriodBreakdown.create!(
        pay_date: Date.new(2025, 1, 1),
        pay_frequency: 14,
        paycheck_amount: 5_000_00
      ).tap do |breakdown|
        breakdown.bill_records << bill_record unless breakdown.bill_records.exists?(bill_record.id)
        breakdown.refresh_bill_total!
      end
    end

    it "updates the bill record amount, redirects back to the pay period, and refreshes totals" do
      sign_in user

      patch bill_record_path(bill_record), params: {
        bill_record: {
          amount: "200.00",
          paid: "0",
          return_to: pay_period_breakdown_path(pay_period_breakdown)
        }
      }

      expect(response).to redirect_to(pay_period_breakdown_path(pay_period_breakdown))
      expect(bill_record.reload.amount).to eq(200_00)
      expect(pay_period_breakdown.reload.bill_total).to eq(200_00)
      expect(pay_period_breakdown.calculate[:bill_amount_remaining]).to eq(200_00)
      expect(pay_period_breakdown.calculate[:leftover_funds]).to eq(4_800_00)
    end
  end
end
