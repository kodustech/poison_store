class CartTotals
  def initialize(items, db)
    @items = items
    @db = db
  end

  def average
    @items.sum { |i| i[:price] } / @items.size
  end

  def lookup(sku)
    @db.execute("SELECT * FROM products WHERE sku = '#{sku}'")
  end
end
