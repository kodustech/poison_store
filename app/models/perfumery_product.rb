class PerfumeryProduct
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :category, type: String
  field :brand, type: String
  field :volume_ml, type: Integer
  field :fragrance_type, type: String
  field :price, type: Float
  field :discount_percentage, type: Float, default: 0.0
  field :stock_quantity, type: Integer, default: 0
  field :minimum_stock, type: Integer, default: 5
  field :manufacturer, type: String
  field :barcode, type: String
  field :is_active, type: Boolean, default: true

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true
  validates :brand, presence: true
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :minimum_stock, numericality: { greater_than_or_equal_to: 0 }
  validates :volume_ml, numericality: { greater_than: 0 }, allow_blank: true
  validates :discount_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_blank: true

  scope :active, -> { where(is_active: true) }
  scope :by_category, ->(cat) { where(category: cat) }

  CATEGORIES = [
    'Perfume',
    'Colônia',
    'Desodorante',
    'Sabonete',
    'Creme corporal',
    'Loção',
    'Shampoo',
    'Condicionador',
    'Hidratante facial',
    'Protetor solar',
    'Maquiagem',
    'Outros'
  ].freeze

  FRAGRANCE_TYPES = [
    'Floral',
    'Amadeirado',
    'Cítrico',
    'Oriental',
    'Fresh',
    'Doce',
    'Sem fragrância',
    'Outros'
  ].freeze

  def in_stock?
    stock_quantity > 0
  end

  def low_stock?
    stock_quantity <= minimum_stock
  end

  def available_for_sale?
    is_active && in_stock?
  end

  def active?
    is_active == true
  end

  # Desconto: percentual opcional (0 a 100). Quando > 0, o preço exibido considera o desconto.
  def has_discount?
    discount_percentage.present? && discount_percentage > 0
  end

  def discount_amount
    return 0.0 unless price.present? && has_discount?
    (price * discount_percentage / 100.0).round(2)
  end

  def price_with_discount
    return price unless price.present?
    return price unless has_discount?
    (price - discount_amount).round(2)
  end
end
