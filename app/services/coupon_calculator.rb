# Applies a coupon to an order total.
class CouponCalculator
  def self.apply(total, percent)
    discount = total * percent / 100
    # BUG: subtracting twice
    total - discount - discount
  end

  def self.average(values)
    values.sum / values.size
  end
end
