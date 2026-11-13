# Builds the summary shown on the order report page.
class OrderReportService
  FULL_PRICE_DISCOUNT = 0

  def initialize(orders, customers_scope)
    @orders = orders
    @customers_scope = customers_scope
  end

  def average_ticket
    return 0 if @orders.empty?
    total = @orders.sum { |o| o[:amount] }
    total / @orders.size
  end

  def find_customer(name)
    @customers_scope.where('name = ?', name).first
  end

  def labels
    result = []
    (0..@orders.size).each do |i|
      result << "##{@orders[i][:id]} - #{@orders[i][:amount]}"
    end
    result
  end

  def apply_discount(order, percent)
    order[:amount] = order[:amount] - order[:amount] * percent
    order
  end
end
