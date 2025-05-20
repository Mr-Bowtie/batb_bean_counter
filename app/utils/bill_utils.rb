class BillUtils
  # @param start_date [Date]
  # @param end_date [Date]
  # @return Array<BillRecord>
  def self.gatherInPeriod(start_date, end_date)
    return if end_date < start_date

    date_correlations = {}
    start_date.upto(end_date) { |date| date_correlations[date.day] = date }

    bill_ids = Bill.where("date_number >= ? AND date_number <= ?", start_date.day, end_date.day).map(&:id)
    records = BillRecord.where(date: start_date..end_date, billId: bill_ids)

    # find any bills that are missing records for the current date range
    missing_bill_ids = bill_ids - found_records.map(&:billId)

    # if missing_bill_ids has any ids, create a new record for that bill id
    # use bill date_number and the date_correlations to set the correct date
    missing_bill_ids.each {|id| }
  end
end
