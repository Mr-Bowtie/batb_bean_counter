# == Schema Information
#
# Table name: payment_sources
#
#  id         :bigint           not null, primary key
#  name       :string
#  type       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class PaymentSourceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
