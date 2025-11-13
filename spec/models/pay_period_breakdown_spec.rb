# == Schema Information
#
# Table name: pay_period_breakdowns
#
#  id              :bigint           not null, primary key
#  next_pay_date   :date
#  pay_date        :date
#  pay_frequency   :integer
#  paycheck_amount :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe PayPeriodBreakdown, type: :model do
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
    let(:breakdown) { described_class.create!(pay_date:, pay_frequency: 14, paycheck_amount: 5_000_00) }

    it 'returns the expected allocation hash based on associated bills' do
      expect(breakdown.calculate).to eq(
        leftover_funds: 3_250_00,
        credit_card_funds: 2_437_50,
        fun_money: 812_50,
        individual_funds: 406_25
      )
    end
  end
end
