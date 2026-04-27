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
  belongs_to :bill, optional: true
  has_and_belongs_to_many :pay_period_breakdowns

  before_validation :assign_default_amount, on: :create
  after_commit :refresh_pay_period_totals, if: :saved_change_to_amount?

  validates :date, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :message_present_for_adhoc_record

  def display_name
    bill&.name.presence || message.presence || "Ad Hoc Bill"
  end

  def source_name
    bill&.payment_source&.name.presence || "Ad hoc bill"
  end

  def every_check?
    bill&.show_each_paycheck || false
  end

  private

  def assign_default_amount
    self.amount ||= bill&.amount
  end

  def refresh_pay_period_totals
    pay_period_breakdowns.find_each(&:refresh_bill_total!)
  end

  def message_present_for_adhoc_record
    return if bill.present? || message.present?

    errors.add(:message, "can't be blank for an ad hoc bill record")
  end
end
