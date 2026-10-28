module RefillReminder
  REMINDER_WINDOW_DAYS = 3

  def self.due?(sale, today: Date.today)
    days_supply = sale.over_the_counter_medication.days_supply.to_i
    return false if days_supply <= 0

    (today - sale.sale_date).to_i >= days_supply - REMINDER_WINDOW_DAYS
  end

  def self.message(sale)
    "Hi #{sale.customer_name}, your #{sale.over_the_counter_medication.name} is about to run out. Come by for a refill."
  end
end
