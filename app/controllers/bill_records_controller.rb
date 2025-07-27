class BillRecordsController < ApplicationController
  before_action :set_bill_record

  def update
    @bill_record.update(paid: params[:paid])
    redirect_back_or_to bills_path
  end


  private

  def set_bill_record
    @bill_record = BillRecord.find(params[:id])
  end
end
