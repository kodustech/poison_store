class MedicationSale
  include Mongoid::Document
  include Mongoid::Timestamps

  field :customer_name, type: String
  field :customer_cpf, type: String
  field :customer_phone, type: String
  field :customer_email, type: String
  field :quantity, type: Integer
  field :unit_price, type: Float
  field :total_price, type: Float
  field :sold_with_prescription, type: Boolean, default: false
  field :prescription_reference, type: String
  field :doctor_name, type: String
  field :doctor_crm, type: String
  field :sale_date, type: Date
  field :payment_method, type: String
  field :notes, type: String

  belongs_to :over_the_counter_medication

  validates :customer_name, presence: true
  validates :customer_cpf, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :sale_date, presence: true
  validates :payment_method, presence: true

  before_validation :calculate_total_price
  after_create :update_stock

  scope :with_prescription, -> { where(sold_with_prescription: true) }
  scope :without_prescription, -> { where(sold_with_prescription: false) }
  scope :by_month, ->(year, month) { where(sale_date: Date.new(year, month, 1)..Date.new(year, month, -1)) }
  scope :by_year, ->(year) { where(sale_date: Date.new(year, 1, 1)..Date.new(year, 12, 31)) }

  private

  def calculate_total_price
    self.total_price = quantity * unit_price if quantity && unit_price
  end

  def update_stock
    medication = over_the_counter_medication
    medication.update(stock_quantity: medication.stock_quantity - quantity)
  end
end
