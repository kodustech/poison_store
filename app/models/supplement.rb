class Supplement
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :supplement_type, type: String
  field :flavor, type: String
  field :weight, type: String
  field :protein_per_serving, type: String
  field :servings_per_container, type: Integer
  field :description, type: String
  field :nutritional_info, type: String
  field :usage_instructions, type: String
  field :price, type: Float
  field :manufacturer, type: String
  field :is_active, type: Boolean, default: true
  field :stock_quantity, type: Integer, default: 0
  field :minimum_stock, type: Integer, default: 10

  has_many :medication_sales

  validates :name, presence: true, uniqueness: true
  validates :supplement_type, presence: true
  validates :weight, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :manufacturer, presence: true
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(is_active: true) }
  scope :by_type, ->(type) { where(supplement_type: type) }

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
