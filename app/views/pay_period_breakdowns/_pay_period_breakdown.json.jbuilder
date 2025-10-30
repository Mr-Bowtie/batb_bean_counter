json.extract! pay_period_breakdown, :id, :paycheck_amount, :pay_date, :next_pay_date, :pay_frequency, :created_at, :updated_at
json.url pay_period_breakdown_url(pay_period_breakdown, format: :json)
