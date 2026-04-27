class CreatePayPeriodAllocations < ActiveRecord::Migration[7.2]
  def up
    create_table :pay_period_allocations do |t|
      t.references :pay_period_breakdown, null: false, foreign_key: true
      t.string :label, null: false
      t.integer :percentage, null: false

      t.timestamps
    end

    execute <<~SQL
      INSERT INTO pay_period_allocations (pay_period_breakdown_id, label, percentage, created_at, updated_at)
      SELECT id, 'Leftover Allocation', credit_card_allocation_pct, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM pay_period_breakdowns
    SQL

    execute <<~SQL
      INSERT INTO pay_period_allocations (pay_period_breakdown_id, label, percentage, created_at, updated_at)
      SELECT id, 'Personal Allocation', individual_allocation_pct, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM pay_period_breakdowns
    SQL

    remove_column :pay_period_breakdowns, :credit_card_allocation_pct, :integer
    remove_column :pay_period_breakdowns, :individual_allocation_pct, :integer
  end

  def down
    add_column :pay_period_breakdowns, :credit_card_allocation_pct, :integer, default: 75, null: false
    add_column :pay_period_breakdowns, :individual_allocation_pct, :integer, default: 25, null: false

    execute <<~SQL
      WITH ranked_allocations AS (
        SELECT pay_period_breakdown_id,
               percentage,
               ROW_NUMBER() OVER (PARTITION BY pay_period_breakdown_id ORDER BY id) AS position
        FROM pay_period_allocations
      )
      UPDATE pay_period_breakdowns
      SET credit_card_allocation_pct = COALESCE(first_allocation.percentage, 75),
          individual_allocation_pct = COALESCE(second_allocation.percentage, 25)
      FROM ranked_allocations AS first_allocation
      LEFT JOIN ranked_allocations AS second_allocation
        ON second_allocation.pay_period_breakdown_id = first_allocation.pay_period_breakdown_id
       AND second_allocation.position = 2
      WHERE pay_period_breakdowns.id = first_allocation.pay_period_breakdown_id
        AND first_allocation.position = 1
    SQL

    drop_table :pay_period_allocations
  end
end
