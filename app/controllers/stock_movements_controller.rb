class StockMovementsController < ApplicationController
  before_action :set_medication, only: [:index, :new, :create]

  def index
    @movements = StockMovement
      .where(over_the_counter_medication: @medication)
      .recent

    @service = InventoryService.new(@medication)
    @restock_suggestion = @service.suggest_restock
  end

  def new
    @movement = StockMovement.new
  end

  def create
    service = InventoryService.new(@medication)
    result = service.register_movement(
      movement_type: params[:stock_movement][:movement_type],
      quantity: params[:stock_movement][:quantity].to_i,
      operator_name: params[:stock_movement][:operator_name],
      reason: params[:stock_movement][:reason],
      unit_cost: params[:stock_movement][:unit_cost],
      reference: params[:stock_movement][:reference]
    )

    if result[:success]
      redirect_to medication_stock_movements_path(@medication),
                  notice: "Movimentação registrada. Novo saldo: #{result[:new_balance]}"
    else
      @movement = StockMovement.new
      flash.now[:alert] = result[:errors].join(', ')
      render :new, status: :unprocessable_entity
    end
  end

  def dashboard
    @low_stock = InventoryService.low_stock_report
    @total_medications = OverTheCounterMedication.active.count
    @out_of_stock = OverTheCounterMedication.active.select { |m| !m.in_stock? }.count
  end

  private

  def set_medication
    @medication = OverTheCounterMedication.find(params[:medication_id])
  end
end
