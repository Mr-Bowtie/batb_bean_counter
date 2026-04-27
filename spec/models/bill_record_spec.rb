# == Schema Information
#
# Table name: bill_records
#
#  id         :bigint           not null, primary key
#  amount     :integer          not null
#  date       :date
#  message    :text
#  paid       :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bill_id    :integer
#
require "rails_helper"

RSpec.describe BillRecord, type: :model do
  describe "callbacks" do
    let(:payment_source) { PaymentSource.create!(name: "Checking", payment_type: :checking_account) }
    let(:bill) do
      Bill.create!(name: "Internet", amount: 80_00, date_number: 10, payment_source:, show_each_paycheck: false)
    end

    it "defaults the bill record amount from the parent bill on create" do
      bill_record = described_class.create!(bill:, date: Date.new(2025, 1, 10))

      expect(bill_record.amount).to eq(80_00)
    end
  end

  describe "validations" do
    it "allows ad hoc bill records without an associated bill" do
      bill_record = described_class.new(
        message: "Parking",
        amount: 25_00,
        date: Date.new(2025, 1, 10)
      )

      expect(bill_record).to be_valid
    end

    it "requires a message for ad hoc bill records" do
      bill_record = described_class.new(amount: 25_00, date: Date.new(2025, 1, 10))

      expect(bill_record).not_to be_valid
      expect(bill_record.errors[:message]).to include("can't be blank for an ad hoc bill record")
    end
  end
end
