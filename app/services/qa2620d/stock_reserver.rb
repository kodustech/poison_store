class StockReserver
  def initialize(store)
    @store = store
  end

  def reserve(sku, qty)
    current = @store[sku] || 0
    @store[sku] = current - qty
  end
end
