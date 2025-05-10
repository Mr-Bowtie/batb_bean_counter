json.extract! bill, :id, :name, :date_number, :amount, :payment_source, :tags, :created_at, :updated_at
json.url bill_url(bill, format: :json)
