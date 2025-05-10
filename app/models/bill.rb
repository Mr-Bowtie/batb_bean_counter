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

  def convertCurrencyForSubmit(input)
  # we need to handle decimal type inputs in all variations, ex: "10.00", "10.2", "10."
    # need to be converted to cent integer
    if input.include?(".")
      amount_parts = input.split(".")
      ## check if any trailing zeros need to added
      if amount_parts.last.length < 2
      trailing_zeros = ""
      (2 - amount_parts.last.length).times {trailing_zeros = trailing_zeros + "0" }
      amount_parts.last = amount_parts.last + trailing_zeros
      end 
      return amount_parts.join("")
    else 
      return input + "00"
    end 

  end
end
