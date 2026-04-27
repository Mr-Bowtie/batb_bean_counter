class BillRecordsController < ApplicationController
  before_action :set_bill_record

  def edit
  end

  def update
    respond_to do |format|
      if @bill_record.update(processed_bill_record_params)
        format.html do
          redirect_to redirect_target, notice: "Bill record was successfully updated."
        end
        format.json { render json: @bill_record, status: :ok }
      else
        format.html { redirect_to redirect_target, alert: @bill_record.errors.full_messages.to_sentence }
        format.json { render json: @bill_record.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_bill_record
    @bill_record = BillRecord.find(params[:id])
  end

  def bill_record_params
    params.require(:bill_record).permit(:amount, :paid, :return_to)
  end

  def processed_bill_record_params
    processed = bill_record_params.to_h

    if processed["amount"].present?
      processed["amount"] = CurrencyUtils.convert_currency_for_submit(processed["amount"])
    end

    processed.except("return_to")
  end

  def redirect_target
    bill_record_params[:return_to].presence || request.referer || bills_path
  end
end
