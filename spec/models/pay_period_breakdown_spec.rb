# == Schema Information
#
# Table name: pay_period_breakdowns
#
#  id                         :bigint           not null, primary key
#  bill_total                 :integer
#  credit_card_allocation_pct :integer          default(75), not null
#  individual_allocation_pct  :integer          default(25), not null
#  next_pay_date              :date
#  pay_date                   :date
#  pay_frequency              :integer
#  paycheck_amount            :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
require 'rails_helper'

RSpec.describe PayPeriodBreakdown, type: :model do
  describe 'validations' do
    it 'requires allocation percentages to total 100' do
      breakdown = described_class.new(
        pay_date: Date.new(2025, 1, 1),
        pay_frequency: 14,
        paycheck_amount: 5_000_00,
        credit_card_allocation_pct: 60,
        individual_allocation_pct: 30
      )

      expect(breakdown).not_to be_valid
      expect(breakdown.errors[:base]).to include("Credit card and individual allocations must total 100%")
    end
  end

  describe 'callbacks' do
    let(:pay_date) { Date.new(2025, 1, 1) }
    let(:pay_frequency) { 14 }
    let(:payment_source) { PaymentSource.create!(name: 'Checking', payment_type: :checking_account) }
    let!(:bill_in_period) do
      Bill.create!(name: 'Rent', amount: 1_500_00, date_number: 5, payment_source:, show_each_paycheck: false)
    end
    let!(:every_check_bill) do
      Bill.create!(name: 'Gym', amount: 250_00, date_number: 25, payment_source:, show_each_paycheck: true)
    end

    it 'calculates the next pay date from pay_date and pay_frequency' do
      breakdown = described_class.create!(pay_date:, pay_frequency:, paycheck_amount: 5_000_00)
      expect(breakdown.next_pay_date).to eq(pay_date + pay_frequency.days)
    end

    it 'associates bill records from the pay period and every check bills' do
      breakdown = described_class.create!(pay_date:, pay_frequency:, paycheck_amount: 5_000_00)

      expect(breakdown.bill_records.pluck(:bill_id)).to contain_exactly(
        bill_in_period.id,
        every_check_bill.id
      )
    end
  end

  describe '#calculate' do
    let(:pay_date) { Date.new(2025, 1, 1) }
    let(:payment_source) { PaymentSource.create!(name: 'Checking', payment_type: :checking_account) }
    let!(:bill_one) do
      Bill.create!(name: 'Rent', amount: 1_500_00, date_number: 1, payment_source:, show_each_paycheck: false)
    end
    let!(:bill_two) do
      Bill.create!(name: 'Electric', amount: 250_00, date_number: 3, payment_source:, show_each_paycheck: false)
    end
    let(:breakdown) do
      described_class.create!(
        pay_date:,
        pay_frequency: 14,
        paycheck_amount: 5_000_00,
        credit_card_allocation_pct: 60,
        individual_allocation_pct: 40
      )
    end

    it 'returns the expected allocation hash based on associated bills and configuration' do
      result = breakdown.calculate

      expect(result).to include(
        bill_amount_remaining: 1_750_00,
        leftover_funds: 3_250_00,
        credit_card_funds: 1_950_00,
        individual_total_funds: 1_300_00,
        individual_funds: 650_00,
        credit_card_allocation_pct: 60,
        individual_allocation_pct: 40
      )
    end

    it 'does not allocate negative leftover funds' do
      breakdown.update!(paycheck_amount: 1_000_00)
      result = breakdown.calculate

      expect(result[:leftover_funds]).to eq(-750_00)
      expect(result[:credit_card_funds]).to eq(0)
      expect(result[:individual_funds]).to eq(0)
      expect(result[:individual_total_funds]).to eq(0)
    end
  end
end
