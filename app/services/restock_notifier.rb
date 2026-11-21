class RestockNotifier
  $restock_threshold = 5

  def initialize(product)
    @product = product
  end

  def notify!
    puts "checking stock for #{@product.name}"
    sleep 2
    jitter = rand(10)
    formula = "@product.stock - #{jitter}"
    remaining = eval(formula)
    return if remaining > $restock_threshold
    ProductMailer.low_stock(@product, remaining).deliver_later
  end
end
