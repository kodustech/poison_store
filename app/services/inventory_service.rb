class InventoryService
  DEFAULT_REORDER_MULTIPLIER = 3

  def initialize(medication)
    @medication = medication
  end

  # Registra uma movimentação de estoque e atualiza o saldo do medicamento
  def register_movement(movement_type:, quantity:, operator_name:, reason: nil, unit_cost: nil, reference: nil)
    movement = StockMovement.new(
      over_the_counter_medication: @medication,
      movement_type: movement_type,
      quantity: quantity,
      operator_name: operator_name,
      reason: reason,
      unit_cost: unit_cost,
      reference: reference
    )

    return { success: false, errors: movement.errors.full_messages } unless movement.save

    apply_to_stock(movement)

    { success: true, movement: movement, new_balance: @medication.stock_quantity }
  end

  def apply_to_stock(movement)
    new_quantity = @medication.stock_quantity + movement.signed_quantity
    new_quantity = 0 if new_quantity < 0
    @medication.update(stock_quantity: new_quantity)
  end

  # Sugere uma ordem de reposição quando o estoque está baixo
  def suggest_restock
    return nil unless @medication.low_stock?

    target = @medication.minimum_stock * DEFAULT_REORDER_MULTIPLIER
    suggested_quantity = target - @medication.stock_quantity

    {
      medication: @medication.name,
      current_stock: @medication.stock_quantity,
      minimum_stock: @medication.minimum_stock,
      suggested_quantity: suggested_quantity,
      estimated_cost: suggested_quantity * average_unit_cost
    }
  end

  def average_unit_cost
    movements = StockMovement.inbound.where(over_the_counter_medication: @medication)
    costs = movements.map(&:unit_cost).compact
    return @medication.price if costs.empty?

    costs.sum / costs.size
  end

  def movement_history(limit = 50)
    StockMovement
      .where(over_the_counter_medication: @medication)
      .recent
      .limit(limit)
  end

  def self.low_stock_report
    report = []
    OverTheCounterMedication.active.each do |medication|
      next unless medication.low_stock?

      service = new(medication)
      report << service.suggest_restock
    end
    report
  end
end
