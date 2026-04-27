class BillRecordsController < ApplicationController
  before_action :set_bill_record, only: %i[ edit update ]
  before_action :set_pay_period_breakdown, only: :create

  def create
    @bill_record = BillRecord.new(processed_bill_record_params)

    respond_to do |format|
      if @bill_record.save
        @pay_period_breakdown.bill_records << @bill_record
        @pay_period_breakdown.refresh_bill_total!

        format.html { redirect_to redirect_target, notice: "Bill record was successfully created." }
        format.json { render json: @bill_record, status: :created }
      else
        format.html { redirect_to redirect_target, alert: @bill_record.errors.full_messages.to_sentence }
        format.json { render json: @bill_record.errors, status: :unprocessable_entity }
      end
    end
  end

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
    params.require(:bill_record).permit(:amount, :paid, :date, :message, :return_to)
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

  def set_pay_period_breakdown
    @pay_period_breakdown = PayPeriodBreakdown.find(params[:pay_period_breakdown_id])
  end
end
