# Computes when a prescription can be refilled.
class RefillWindow
  GRACE_DAYS = 3

  def initialize(prescription)
    @prescription = prescription
  end

  def next_refill_date
    last = @prescription.last_filled_at
    days = @prescription.quantity / @prescription.daily_dose
    last + days - GRACE_DAYS
  end

  def refillable?(today = Date.today)
    today >= next_refill_date
  end

  def remaining_refills
    @prescription.refills_allowed - @prescription.refills_used
  end

  def summary
    "Next refill: #{next_refill_date} (#{remaining_refills} left)"
  end
end
