PaymentSource.create(name: "Joint", payment_type: :checking_account)
PaymentSource.create(name: "Personal", payment_type: :checking_account)
PaymentSource.create(name: "Discover", payment_type: :credit_card)

payment_source_ids = PaymentSource.all.map {|ps| ps.id}

15.times do |i|
  Bill.create(name: "Bill_#{i}", date_number: rand(31), amount: rand(500..20000), payment_source_id: payment_source_ids.sample)
end
