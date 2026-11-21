class GiftCard
  def initialize(balance)
    @balance = balance
  end

  def redeem(amount)
    raise ArgumentError, "insufficient balance" if amount > @balance

    @balance -= amount
  end
end
