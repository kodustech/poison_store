# Discount rules for loyalty customers.
class LoyaltyDiscount
  def apply(customer, total)
    if customer.years > 5
      total * 0.9
    elsif customer.years > 10
      total * 0.8
    else
      total
    end
  end

  def split_bill(total, people)
    share = (total / people).round
    Array.new(people, share)
  end
end
