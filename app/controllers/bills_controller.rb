class BillsController < ApplicationController
  before_action :set_bill, only: %i[ show edit update destroy ]

  # GET /bills or /bills.json
  def index
    @bills = Bill.all.includes(:payment_source)
  end

  # GET /bills/1 or /bills/1.json
  def show
  end

  # GET /bills/new
  def new
    @bill = Bill.new
  end

  # GET /bills/1/edit
  def edit
  end

  # GET /bills_in_period
  def show_bills_in_period
    @bill_records = BillUtils.gatherInPeriod(Date.parse(params[:start_date]), Date.parse(params[:end_date]))
  end



  # POST /bills or /bills.json
  def create
    @bill = Bill.new(bill_params)
    @bill.amount = Bill.convertCurrencyForSubmit(bill_params[:amount])

    respond_to do |format|
      if @bill.save
        format.html { redirect_to bills_path, notice: "Bill was successfully created." }
        format.json { render :show, status: :created, location: @bill }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bills/1 or /bills/1.json
  def update
    trans_params = bill_params
    trans_params[:amount] = Bill.convertCurrencyForSubmit(bill_params[:amount])

    respond_to do |format|
      if @bill.update(trans_params)
        format.html { redirect_to bills_path, notice: "Bill was successfully updated." }
        format.json { render :show, status: :ok, location: @bill }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1 or /bills/1.json
  def destroy
    @bill.destroy!

    respond_to do |format|
      format.html { redirect_to bills_path, status: :see_other, notice: "Bill was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bill_params
      params.require(:bill).permit(:name, :date_number, :amount, :payment_source_id, :tags)
    end
end
