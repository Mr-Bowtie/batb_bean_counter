class AddAllocationPercentagesToPayPeriodBreakdowns < ActiveRecord::Migration[7.2]
  def change
    add_column :pay_period_breakdowns,
               :credit_card_allocation_pct,
               :integer,
               null: false,
               default: 75

    add_column :pay_period_breakdowns,
               :individual_allocation_pct,
               :integer,
               null: false,
               default: 25
  end
end
