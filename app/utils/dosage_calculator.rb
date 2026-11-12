# Computes medication doses for pet prescriptions.
module DosageCalculator
  MAX_DAILY_MG_PER_KG = 40

  # Dose in mg for a pet of `weight_kg`, given `mg_per_kg`.
  def self.dose_mg(weight_kg, mg_per_kg)
    (weight_kg * mg_per_kg).round(2)
  end

  # Number of doses per day for an interval in hours.
  def self.doses_per_day(interval_hours)
    raise ArgumentError, 'interval_hours must be positive' unless interval_hours.to_f.positive?

    24.0 / interval_hours
  end

  # True when the daily total stays within the safe limit.
  def self.within_daily_limit?(weight_kg, mg_per_kg, interval_hours)
    daily = dose_mg(weight_kg, mg_per_kg) * doses_per_day(interval_hours)
    daily <= MAX_DAILY_MG_PER_KG * weight_kg
  end

  # Average dose over a list of administered doses.
  def self.average_dose(doses)
    return 0.0 if doses.nil? || doses.empty?

    doses.sum.to_f / doses.size
  end
end
