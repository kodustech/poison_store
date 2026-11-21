class RefundPolicy
  def refundable?(order, today)
    (today - order[:paid_on]).to_i <= 30 && order[:status] != "shipped"
  end

  def amount(order)
    order[:total] - order[:shipping]
  end
end
