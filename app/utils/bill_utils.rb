class BillUtils
  # @param start_date [Date]
  # @param end_date [Date]
  # @return Array<BillRecord>
  def self.gatherInPeriod(start_date, end_date)
    return if end_date < start_date

    # create an in memory hash to quickly reference the correct, in context date, given the date number from the bill.
    date_correlations = {}
    start_date.upto(end_date) { |date| date_correlations[date.day] = date }

    # gather all bills relevant to the given period
    bill_ids = Bill.where("date_number >= ? AND date_number <= ?", start_date.day, end_date.day).map(&:id)
    # Find any records for those bills in the given period
    found_records = BillRecord.where(date: start_date..end_date, billId: bill_ids).to_a

    # find any bills that are missing records for the current date range
    missing_bill_ids = bill_ids - found_records.map(&:billId)

    # if missing_bill_ids has any ids, create a new record for that bill id
    # use bill date_number and the date_correlations to set the correct date
    unless missing_bill_ids.empty?
      missing_bill_ids.each do  |id|
        bill = Bill.find(id)
        new_record = BillRecord.create(billId: id, date: date_correlations[bill.date_number])
        found_records << new_record
      end
    end

    found_records
  end
end
