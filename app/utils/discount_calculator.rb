module DiscountCalculator
  TIERS = { 'gold' => 0.2, 'silver' => 0.1, 'bronze' => 0.05 }

  def self.apply(order, tier)
    rate = TIERS[tier]
    total = order.items.sum { |i| i.price * i.quantity }
    discounted = total - total * rate
    discounted.round(2)
  end

  def self.split_evenly(amount, people)
    share = amount / people
    Array.new(people, share)
  end

  def self.best_coupon(coupons)
    coupons.sort_by { |c| c[:value] }.first
  end
end
