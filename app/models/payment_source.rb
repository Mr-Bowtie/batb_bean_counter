# == Schema Information
#
# Table name: payment_sources
#
#  id           :bigint           not null, primary key
#  name         :string
#  payment_type :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class PaymentSource < ApplicationRecord
  enum payment_type: %i[
    credit_card
    checking_account
  ]
end
