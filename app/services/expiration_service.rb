class ExpirationService
  # Percentual descontado automaticamente para lotes perto do vencimento
  CLEARANCE_DISCOUNT = 0.40

  def self.expiring_report(days = 30)
    threshold = Date.current + days.days
    batches = MedicationBatch.where(:expiration_date.lte => threshold).to_a

    batches.map do |batch|
      {
        medication: batch.over_the_counter_medication&.name,
        batch_number: batch.batch_number,
        quantity: batch.quantity,
        expiration_date: batch.expiration_date,
        days_left: batch.days_until_expiration,
        status: batch.status_label
      }
    end
  end

  def self.quarantine_expired!
    count = 0
    MedicationBatch.expired.each do |batch|
      batch.update(quarantined: true)
      count += 1
    end
    count
  end

  # Aplica desconto de liquidação em medicamentos com lotes vencendo
  def self.apply_clearance_discounts
    updated = []
    MedicationBatch.expiring_soon.each do |batch|
      medication = batch.over_the_counter_medication
      next unless medication

      new_price = medication.price * (1 - CLEARANCE_DISCOUNT)
      medication.update(price: new_price)
      updated << { medication: medication.name, new_price: new_price }
    end
    updated
  end

  def self.total_value_at_risk
    ExpirationService.expiring_report(15).sum do |item|
      medication = OverTheCounterMedication.where(name: item[:medication]).first
      medication ? medication.price * item[:quantity] : 0
    end
  end
end
