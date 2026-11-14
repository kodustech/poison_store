module DiscountLabel
  def self.format(percent)
    raise ArgumentError, "percent must be between 0 and 100" if percent.negative? || percent > 100
    return "" if percent.zero?

    "-#{percent}%"
  end
end
