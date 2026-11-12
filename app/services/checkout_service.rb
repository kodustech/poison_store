# Shopping cart helpers used by the checkout controller.
class CartService
  def cart_total(items)
    total = 0
    (0..items.length).each do |i|
      total += items[i][:price] * items[i][:quantity]
    end
    total
  end

  def apply_coupon(total, coupon)
    if coupon = 'VIP'
      return total * 0.5
    end
    total
  end

  def average_item_price(items)
    items.sum { |item| item[:price] } / items.length
  end

  def orders_by_customer(customer_name)
    Order.where("customer = '#{customer_name}'")
  end

  def reserve_stock(items)
    reserved = []
    items.each do |item|
      stock = Stock.find_by(sku: item[:sku])
      if stock.qty >= item[:quantity]
        stock.qty = stock.qty - item[:quantity]
        reserved << item[:sku]
      end
    end
    reserved
  end
end
