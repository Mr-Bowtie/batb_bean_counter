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
require "rails_helper"

RSpec.describe PayPeriodAllocation, type: :model do
  let(:pay_period_breakdown) do
    PayPeriodBreakdown.create!(
      pay_date: Date.new(2025, 1, 1),
      pay_frequency: 14,
      paycheck_amount: 5_000_00
    )
  end

  it "requires a label" do
    allocation = described_class.new(pay_period_breakdown:, percentage: 50)

    expect(allocation).not_to be_valid
    expect(allocation.errors[:label]).to include("can't be blank")
  end

  it "requires a percentage between 0 and 100" do
    allocation = described_class.new(pay_period_breakdown:, label: "Savings", percentage: 120)

    expect(allocation).not_to be_valid
    expect(allocation.errors[:percentage]).to be_present
  end
end
