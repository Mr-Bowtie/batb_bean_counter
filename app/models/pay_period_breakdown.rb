# == Schema Information
#
# Table name: pay_period_breakdowns
#
#  id              :bigint           not null, primary key
#  bill_total      :integer
#  next_pay_date   :date
#  pay_date        :date
#  pay_frequency   :integer
#  paycheck_amount :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class PayPeriodBreakdown < ApplicationRecord
  before_validation :populate_next_pay_date
  after_create_commit :associate_period_bill_records
  after_create_commit :create_every_check_bill_records
  after_create_commit :set_bill_total

  has_and_belongs_to_many :bill_records, -> { order(:date) }

  validates :pay_date, :next_pay_date, :pay_frequency, :paycheck_amount, presence: true
  validates :pay_frequency, numericality: { only_integer: true, greater_than: 0 }
  validates :paycheck_amount, numericality: { greater_than: 0 }
  validate :next_pay_date_after_pay_date

  def bills
    bill_records
  end

  def calculate
    bill_amount_remaining = BillUtils.sum_paid_records(bills)
    leftover_funds = paycheck_amount - bill_total
    credit_card_funds = (leftover_funds * 75) / 100
    individual_funds = (leftover_funds - credit_card_funds) / 2

    {
      bill_amount_remaining: bill_amount_remaining,
      leftover_funds: leftover_funds,
      credit_card_funds: credit_card_funds,
      individual_funds: individual_funds
    }
  end

  def associate_period_bill_records
    return if pay_date.blank? || next_pay_date.blank?

    records = BillUtils.gatherInPeriod(pay_date, next_pay_date - 1.day)
    records.each { |record| add_bill_record(record) }
  end

  def create_every_check_bill_records
    BillRecord.transaction do
      Bill.where(show_each_paycheck: true).find_each do |bill|
        record = BillRecord.find_or_create_by!(bill_id: bill.id, date: pay_date)
        add_bill_record(record)
      end
    end
  end

  private

  def add_bill_record(record)
    bill_records << record unless bill_records.exists?(record.id)
  end

  def populate_next_pay_date
    return if pay_date.blank? || pay_frequency.blank?

    self.next_pay_date = pay_date + pay_frequency.days
  end

  def next_pay_date_after_pay_date
    return if pay_date.blank? || next_pay_date.blank?
    return if next_pay_date > pay_date

    errors.add(:next_pay_date, "must be after pay_date")
  end

  def set_bill_total
    # all records will be unpaid upon creation so summing now will return total
    self.bill_total = BillUtils.sum_records_total(bills)
    save!
  end
end
