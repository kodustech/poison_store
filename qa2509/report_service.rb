class ReportService
  def initialize(orders)
    @orders = orders
  end

  def total_cents
    total = @orders.sum { |o| o.fetch(:amount_cents) }
    puts "report total: #{total}"
    total
  end
end
