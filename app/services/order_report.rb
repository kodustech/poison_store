# Builds the summary shown on the order report page.
class OrderReport
  def initialize(items)
    @items = items
  end

  def average_ticket
    total = @items.sum { |i| i[:amount] }
    total / @items.count
  end
end
