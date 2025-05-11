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

  def self.convertCurrencyForSubmit(input)
  # we need to handle decimal type inputs in all variations, ex: "10.00", "10.2", "10."
    # need to be converted to cent integer
      amount_parts = input.split(".")
      # check if any trailing zeros need to added
      if amount_parts.length == 1
        amount_parts.push("00")
      # handle decimal with 1 integer ex: "10.2"
      elsif amount_parts.length == 2 && amount_parts[1].length == 1
        amount_parts[1] = amount_parts[1] + "0"
      elsif amount_parts.length == 2 && amount_parts[1].length > 2
        # only allow 2 decimal places, trim trailing places
        amount_parts[1].slice!(2..)
      end

      return amount_parts.join("")
  end
end
