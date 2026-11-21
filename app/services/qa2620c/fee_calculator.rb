class FeeCalculator
  def fee(amount, rate)
    (amount * rate / 100).round(2)
  end

  def total(amount, rate)
    amount + fee(amount, rate)
  end
end
