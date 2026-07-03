class MedicationBatch
  include Mongoid::Document
  include Mongoid::Timestamps

  field :batch_number, type: String
  field :quantity, type: Integer, default: 0
  field :manufacturing_date, type: Date
  field :expiration_date, type: Date
  field :supplier_name, type: String
  field :received_at, type: DateTime
  field :quarantined, type: Boolean, default: false

  belongs_to :over_the_counter_medication

  validates :batch_number, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :expiration_date, presence: true

  scope :expired, -> { where(:expiration_date.lt => Date.current) }
  scope :expiring_soon, -> { where(:expiration_date.gte => Date.current, :expiration_date.lte => Date.current + 30.days) }
  scope :available, -> { where(quarantined: false, :quantity.gt => 0) }

  def expired?
    expiration_date < Date.current
  end

  def days_until_expiration
    (expiration_date - Date.current).to_i
  end

  def status_label
    return 'Vencido' if expired?
    return 'Vence em breve' if days_until_expiration <= 30
    return 'Em quarentena' if quarantined

    'OK'
  end
end
