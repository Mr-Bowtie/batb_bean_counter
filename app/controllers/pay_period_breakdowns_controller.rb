class PayPeriodBreakdownsController < ApplicationController
  before_action :set_pay_period_breakdown, only: %i[ show edit update destroy ]

  # GET /pay_period_breakdowns or /pay_period_breakdowns.json
  def index
    @pay_period_breakdowns = PayPeriodBreakdown.all
  end

  # GET /pay_period_breakdowns/1 or /pay_period_breakdowns/1.json
  def show
    @bill_records = @pay_period_breakdown.bill_records.includes(:bill).joins(:bill).order("bills.date_number")
    @calculation = @pay_period_breakdown.calculate
    @remaining_bill_total_cents = @calculation[:bill_amount_remaining]
  end

  # GET /pay_period_breakdowns/new
  def new
    @pay_period_breakdown = PayPeriodBreakdown.new
  end

  # GET /pay_period_breakdowns/1/edit
  def edit
  end

  # POST /pay_period_breakdowns or /pay_period_breakdowns.json
  def create
    @pay_period_breakdown = PayPeriodBreakdown.new(pay_period_breakdown_params)
    @pay_period_breakdown.paycheck_amount = CurrencyUtils.convert_currency_for_submit(pay_period_breakdown_params[:paycheck_amount])

    respond_to do |format|
      if @pay_period_breakdown.save
        format.html { redirect_to @pay_period_breakdown, notice: "Pay period breakdown was successfully created." }
        format.json { render :show, status: :created, location: @pay_period_breakdown }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pay_period_breakdown.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pay_period_breakdowns/1 or /pay_period_breakdowns/1.json
  def update
    respond_to do |format|
      if @pay_period_breakdown.update(pay_period_breakdown_params)
        format.html { redirect_to @pay_period_breakdown, notice: "Pay period breakdown was successfully updated." }
        format.json { render :show, status: :ok, location: @pay_period_breakdown }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pay_period_breakdown.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pay_period_breakdowns/1 or /pay_period_breakdowns/1.json
  def destroy
    @pay_period_breakdown.destroy!

    respond_to do |format|
      format.html { redirect_to pay_period_breakdowns_path, status: :see_other, notice: "Pay period breakdown was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pay_period_breakdown
      @pay_period_breakdown = PayPeriodBreakdown.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pay_period_breakdown_params
      params.require(:pay_period_breakdown).permit(:paycheck_amount, :pay_date, :pay_frequency)
    end
end
