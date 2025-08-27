class OverTheCounterMedication
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :price, type: Float
  field :active_ingredient, type: String
  field :dosage_form, type: String
  field :strength, type: String
  field :manufacturer, type: String
  field :requires_prescription, type: Boolean, default: false
  field :is_active, type: Boolean, default: true
  field :stock_quantity, type: Integer, default: 0
  field :minimum_stock, type: Integer, default: 10

  has_many :medication_sales

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :active_ingredient, presence: true
  validates :dosage_form, presence: true
  validates :strength, presence: true
  validates :manufacturer, presence: true
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(is_active: true) }
  scope :requires_prescription, -> { where(requires_prescription: true) }
  scope :no_prescription_required, -> { where(requires_prescription: false) }

  def in_stock?
    stock_quantity > 0
  end

  def low_stock?
    stock_quantity <= minimum_stock
  end

  def available_for_sale?
    is_active && in_stock?
  end
end
