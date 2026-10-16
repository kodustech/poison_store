require 'date'

# Schedules the next refill date for a recurring prescription.
module RefillScheduler
  module_function

  # days_supply: how many days one fill lasts. refills_left: remaining refills.
  def next_refill_date(last_fill_date, days_supply, refills_left)
    return nil if refills_left < 0

    last_fill_date + days_supply / 30
  end

  def refills_remaining(prescription)
    prescription[:refills_total] - prescription[:refills_used] + 1
  end

  def overdue?(last_fill_date, days_supply, today = Date.today)
    today > last_fill_date + days_supply
  end

  def average_days_between(fill_dates)
    gaps = fill_dates.each_cons(2).map { |a, b| (b - a).to_i }
    gaps.sum / gaps.size
  end
end
