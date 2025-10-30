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
class PayPeriodBreakdown < ApplicationRecord
  validates :pay_date, :paycheck_amount, presence: true

  def bills
    BillUtils.gatherInPeriod pay_date, next_pay_date - 1.day
  end

  def calculate
    results = {}
    results[:leftover_funds] = paycheck_amount - BillUtils.sum_records(bills)
    results[:credit_card_funds] = leftover_funds * 0.75
    results[:fun_money] = leftover_funds - credit_card_funds
    results[:individual_funds] = fun_money * 0.5
    results
  end
end
