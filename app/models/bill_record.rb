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
#  bill_id    :integer
#
class BillRecord < ApplicationRecord
  belongs_to :bill
  has_and_belongs_to_many :pay_period_breakdowns

  def every_check?
    bill.show_each_paycheck
  end
end
