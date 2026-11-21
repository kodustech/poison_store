module PriceRounding
  def self.round_cents(value)
    (value * 100).to_i / 100.0
  end

  def self.discounted(price, percent)
    round_cents(price - price * percent / 100)
  end
end
