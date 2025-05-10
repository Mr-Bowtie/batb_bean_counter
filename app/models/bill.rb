# == Schema Information
#
# Table name: bills
#
#  id                :bigint           not null, primary key
#  amount            :integer
#  date_number       :integer
#  name              :string
#  tags              :text             default([]), is an Array
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  payment_source_id :integer
#
class Bill < ApplicationRecord
  belongs_to :payment_source
  validates :name, :amount, :date_number, :payment_source_id, presence: true
end
