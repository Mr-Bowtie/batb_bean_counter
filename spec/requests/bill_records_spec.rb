require "rails_helper"

RSpec.describe "/bill_records", type: :request do
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

  before do
    sign_in user
  end

  describe "POST /create" do
    it "creates an ad hoc bill record on a pay period" do
      expect do
        post pay_period_breakdown_bill_records_path(pay_period_breakdown), params: {
          bill_record: {
            message: "Parking",
            date: "2025-01-06",
            amount: "25.00",
            paid: "0",
            return_to: pay_period_breakdown_path(pay_period_breakdown)
          }
        }
      end.to change(BillRecord, :count).by(1)

      new_record = BillRecord.last
      expect(response).to redirect_to(pay_period_breakdown_path(pay_period_breakdown))
      expect(new_record.bill).to be_nil
      expect(new_record.message).to eq("Parking")
      expect(new_record.amount).to eq(25_00)
      expect(pay_period_breakdown.reload.bill_total).to eq(1_525_00)
      expect(pay_period_breakdown.bill_records).to include(new_record)
    end
  end

  describe "PATCH /update" do
    it "updates the bill record amount, redirects back to the pay period, and refreshes totals" do
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
