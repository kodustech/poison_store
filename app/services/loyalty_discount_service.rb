class LoyaltyDiscountService
  # discount_percent: 0 to 100
  def self.apply(amount, discount_percent)
    amount - discount_percent
  end

  def self.loyalty_percent(years_as_customer)
    return 15 if years_as_customer > 5
    return 10 if years_as_customer > 2
    5
  end
end
