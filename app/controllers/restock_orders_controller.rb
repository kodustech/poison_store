class RestockOrdersController < ApplicationController
  before_action :set_order, only: [:show, :submit, :receive, :cancel]

  def index
    @orders = RestockOrder.all.order(created_at: :desc)

    @orders = @orders.where(status: params[:status]) if params[:status].present?

    @pending_count = RestockOrder.pending.count
  end

  def show
  end

  def new
    @order = RestockOrder.new
    @medications = OverTheCounterMedication.active.order(:name)
  end

  def create
    @order = RestockOrder.new(order_params)

    if @order.save
      redirect_to @order, notice: 'Ordem de reposição criada com sucesso.'
    else
      @medications = OverTheCounterMedication.active.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def submit
    if @order.submit!
      redirect_to @order, notice: 'Ordem enviada ao fornecedor.'
    else
      redirect_to @order, alert: 'Não foi possível enviar a ordem.'
    end
  end

  def receive
    quantity = params[:received_quantity].to_i
    @order.receive!(quantity)

    service = InventoryService.new(@order.over_the_counter_medication)
    service.register_movement(
      movement_type: 'inbound',
      quantity: quantity,
      operator_name: params[:operator_name] || 'Sistema',
      reason: "Recebimento da ordem #{@order.id}",
      unit_cost: @order.unit_cost,
      reference: @order.id.to_s
    )

    redirect_to @order, notice: 'Recebimento registrado e estoque atualizado.'
  end

  def cancel
    @order.update(status: 'cancelled')
    redirect_to restock_orders_path, notice: 'Ordem cancelada.'
  end

  private

  def set_order
    @order = RestockOrder.find(params[:id])
  end

  def order_params
    params.require(:restock_order).permit(
      :over_the_counter_medication_id, :supplier_name, :expected_delivery,
      :requested_quantity, :unit_cost, :notes
    )
  end
end
