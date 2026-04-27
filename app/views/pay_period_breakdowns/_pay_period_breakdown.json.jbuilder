json.extract! pay_period_breakdown,
              :id,
              :paycheck_amount,
              :pay_date,
              :next_pay_date,
              :pay_frequency,
              :created_at,
              :updated_at
json.allocations pay_period_breakdown.pay_period_allocations do |allocation|
  json.extract! allocation, :id, :label, :percentage
end
json.url pay_period_breakdown_url(pay_period_breakdown, format: :json)
