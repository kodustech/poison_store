module StockBadge
  def self.text(qty)
    return "Out of stock" if qty.zero?
    return "Only #{qty} left" if qty <= 5

    "In stock"
  end
end
