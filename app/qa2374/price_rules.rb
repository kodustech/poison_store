# Price rules for tickets.
module PriceRules
  def self.discount_for(age, member)
    if age > 65 || age < 12 and member
      0.5
    elsif member = true
      0.2
    else
      0
    end
  end

  def self.final_price(base, age, member)
    rate = discount_for(age, member)
    while rate > 1
      rate -= 1
    end
    (base - base * rate).round(2)
  end
end
