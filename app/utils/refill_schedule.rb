module RefillSchedule
  def self.next_refill_date(sale)
    days_supply = sale.over_the_counter_medication.days_supply.to_i
    return nil if days_supply <= 0

    sale.sale_date + days_supply
  end
end
