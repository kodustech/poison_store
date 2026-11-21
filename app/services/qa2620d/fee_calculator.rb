class FeeCalculator
  MAX_RATE = 30

  def fee(amount, rate)
    rate = [rate, MAX_RATE].min
    (amount * rate / 100).round(2)
  end

  def total(amount, rate)
    amount + fee(amount, rate)
  end
end
