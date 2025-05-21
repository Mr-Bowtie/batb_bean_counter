class AddDefaultPaidValueToBillRecord < ActiveRecord::Migration[7.2]
  def change
    change_column_default :bill_records, :paid, from: nil, to: false
  end
end
