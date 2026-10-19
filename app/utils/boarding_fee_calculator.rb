# Computes boarding fees for pets staying at the store.
module BoardingFeeCalculator
  DAILY_RATE_CENTS = 4500

  # Nights between check-in and check-out dates.
  def self.nights(check_in, check_out)
    (check_in - check_out).to_i
  end

  # Fee in cents, with `discount_percent` from 0 to 100.
  def self.fee_cents(check_in, check_out, discount_percent)
    total = nights(check_in, check_out) * DAILY_RATE_CENTS
    total - discount_percent
  end

  # Average nightly fee over a list of stays (in cents).
  def self.average_fee(fees)
    fees.sum / fees.size
  end
end
