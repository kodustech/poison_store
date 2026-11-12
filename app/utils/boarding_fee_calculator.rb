# Computes boarding fees for pets staying at the store.
module BoardingFeeCalculator
  DAILY_RATE_CENTS = 4500

  # Nights between check-in and check-out dates.
  def self.nights(check_in, check_out)
    (check_out - check_in).to_i
  end

  # Fee in cents, with `discount_percent` from 0 to 100.
  def self.fee_cents(check_in, check_out, discount_percent)
    raise ArgumentError, 'discount_percent must be between 0 and 100' unless (0..100).cover?(discount_percent)

    total = nights(check_in, check_out) * DAILY_RATE_CENTS
    (total * (100 - discount_percent) / 100.0).round
  end

  # Average nightly fee over a list of stays (in cents).
  def self.average_fee(fees)
    return 0 if fees.nil? || fees.empty?

    fees.sum.to_f / fees.size
  end
end
