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
require "test_helper"

class BillRecordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
