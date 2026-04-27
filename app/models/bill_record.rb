# == Schema Information
#
# Table name: bill_records
#
#  id         :bigint           not null, primary key
#  date       :date
#  message    :text
#  paid       :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  amount     :integer          not null
#  bill_id    :integer
#
class BillRecord < ApplicationRecord
  belongs_to :bill
  has_and_belongs_to_many :pay_period_breakdowns

  before_validation :assign_default_amount, on: :create
  after_commit :refresh_pay_period_totals, if: :saved_change_to_amount?

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def every_check?
    bill.show_each_paycheck
  end

  private

  def assign_default_amount
    self.amount ||= bill&.amount
  end

  def refresh_pay_period_totals
    pay_period_breakdowns.find_each(&:refresh_bill_total!)
  end
end
