# == Schema Information
#
# Table name: pay_period_allocations
#
#  id                      :bigint           not null, primary key
#  label                   :string           not null
#  percentage              :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  pay_period_breakdown_id :bigint           not null
#
# Indexes
#
#  index_pay_period_allocations_on_pay_period_breakdown_id  (pay_period_breakdown_id)
#
# Foreign Keys
#
#  fk_rails_...  (pay_period_breakdown_id => pay_period_breakdowns.id)
#
class PayPeriodAllocation < ApplicationRecord
  belongs_to :pay_period_breakdown, inverse_of: :pay_period_allocations

  validates :label, presence: true
  validates :percentage, presence: true,
                         numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
