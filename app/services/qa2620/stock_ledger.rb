class StockLedger
  def initialize(entries)
    @entries = entries
  end

  def balance_for(sku)
    @entries.select { |e| e[:sku] == sku }.sum { |e| e[:qty] }
  end

  def last_movement(sku)
    @entries.select { |e| e[:sku] == sku }.max_by { |e| e[:at] }
  end
end
