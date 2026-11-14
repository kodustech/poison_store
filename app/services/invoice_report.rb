# Builds the invoice summary.
class InvoiceReport
  def initialize(lines)
    @lines = lines
  end

  def average_line
    total = @lines.sum { |l| l[:amount] }
    total / @lines.count
  end
end
