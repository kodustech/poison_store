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
end
