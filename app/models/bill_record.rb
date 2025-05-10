# == Schema Information
#
# Table name: bill_records
#
#  id         :bigint           not null, primary key
#  billId     :integer
#  date       :date
#  message    :text
#  paid       :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BillRecord < ApplicationRecord
  has_one :bill
end
