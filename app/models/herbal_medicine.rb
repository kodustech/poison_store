class HerbalMedicine
  include Mongoid::Document
  include Mongoid::Timestamps

  field :commercial_name, type: String
  field :scientific_name, type: String
  field :plant_part, type: String
  field :dosage_form, type: String
  field :description, type: String
  field :therapeutic_indications, type: String
  field :contraindications, type: String
  field :drug_interactions, type: String
  field :price, type: Float
  field :manufacturer, type: String
  field :is_active, type: Boolean, default: true
  field :stock_quantity, type: Integer, default: 0
  field :minimum_stock, type: Integer, default: 10

  has_many :medication_sales

  validates :commercial_name, presence: true, uniqueness: true
  validates :scientific_name, presence: true
  validates :plant_part, presence: true
  validates :dosage_form, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :manufacturer, presence: true
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(is_active: true) }

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
