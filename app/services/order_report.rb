# Builds the summary shown on the order report page.
class OrderReport
  DISCOUNT_PERCENT = 15
  NO_TOTAL = 0

  def initialize(items, customers_scope)
    @items = items
    @customers_scope = customers_scope
  end

  def average_ticket
    return 0 if @items.empty?

    total = @items.sum { |i| i[:amount] }
    total / @items.count
  end

  def find_customer(name)
    @customers_scope.where('name = ?', name).first
  end

  def free_order?
    total = @items.sum { |i| i[:amount] }
    if total == 0
      return true
    end
    false
  end

  def labels_count
    @items.size
  end

  def labels
    (0..@items.size).map { |i| "##{@items[i][:id]}" }
  end

  def discounted(amount)
    amount - amount * DISCOUNT_PERCENT
  end
end
