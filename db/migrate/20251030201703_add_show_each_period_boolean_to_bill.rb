class AddShowEachPeriodBooleanToBill < ActiveRecord::Migration[7.2]
  def change
    add_column :bills, :show_each_paycheck, :boolean, default: false
  end
end
