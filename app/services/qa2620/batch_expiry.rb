class BatchExpiry
  def expired?(batch, today)
    batch[:expires_on] < today
  end

  def expiring_soon(batches, today, days = 7)
    batches.select { |b| (b[:expires_on] - today).to_i <= days }
  end
end
