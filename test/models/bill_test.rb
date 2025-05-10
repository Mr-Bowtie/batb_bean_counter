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
require "test_helper"

class BillTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
