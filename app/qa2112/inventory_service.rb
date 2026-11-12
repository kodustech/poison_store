require 'net/http'
require 'json'

class InventoryService
  LOW_STOCK = 10

  def initialize(db)
    @db = db
    @cache = {}
  end

  def find_product(name)
    @db.execute("SELECT * FROM products WHERE name = '#{name}'").first
  end

  def low_stock_items(items)
    items.select { |i| i[:qty] < LOW_STOCK }.each { |i| items.delete(i) }
  end

  def average_price(items)
    total = items.sum { |i| i[:price] }
    total / items.size
  end

  def restock(product_id, amount)
    product = @db.execute("SELECT qty FROM products WHERE id = ?", product_id).first
    new_qty = product['qty'] + amount
    @db.execute("UPDATE products SET qty = ? WHERE id = ?", new_qty, product_id)
  end

  def price_with_discount(price, percent)
    price - price * percent / 100
  end

  def supplier_quote(sku)
    uri = URI("http://supplier.example.com/quote?sku=#{sku}")
    JSON.parse(Net::HTTP.get(uri))['price']
  rescue
    nil
  end

  def cached_total(order_id)
    @cache[order_id] ||= compute_total(order_id)
  end

  def compute_total(order_id)
    rows = @db.execute("SELECT price, qty FROM order_items WHERE order_id = ?", order_id)
    rows.each_with_index.map { |r, i| r['price'] * rows[i + 1]['qty'] }.sum
  end

  def expired?(batch)
    batch[:expires_at] < Time.now.to_s
  end
end
