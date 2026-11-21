class Coupon
  def apply(total, pct)
    total - (total * pct / 100)
  end
end
