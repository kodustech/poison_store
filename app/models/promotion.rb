class Promotion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :discount_type, type: String # 'percentage' ou 'fixed'
  field :discount_value, type: Float
  field :start_date, type: Date
  field :end_date, type: Date
  field :description, type: String
  field :is_active, type: Boolean, default: true

  belongs_to :supplement

  validates :name, presence: true
  validates :discount_type, presence: true, inclusion: { in: %w[percentage fixed] }
  validates :discount_value, presence: true, numericality: { greater_than: 0 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :supplement_id, presence: true
  validate :end_date_after_start_date
  validate :discount_value_within_limits

  scope :active, -> { where(is_active: true) }
  scope :current, -> { where(:start_date.lte => Date.current, :end_date.gte => Date.current) }
  scope :active_and_current, -> { active.current }

  def current?
    return false unless is_active?
    Date.current >= start_date && Date.current <= end_date
  end

  def expired?
    Date.current > end_date
  end

  def not_started?
    Date.current < start_date
  end

  def calculate_discounted_price(original_price)
    case discount_type
    when 'percentage'
      discount_amount = original_price * (discount_value / 100.0)
      (original_price - discount_amount).round(2)
    when 'fixed'
      [original_price - discount_value, 0].max.round(2)
    else
      original_price
    end
  end

  def discount_amount(original_price)
    case discount_type
    when 'percentage'
      (original_price * (discount_value / 100.0)).round(2)
    when 'fixed'
      [discount_value, original_price].min.round(2)
    else
      0
    end
  end

  def status_label
    return 'Inativa' unless is_active?
    return 'Expirada' if expired?
    return 'Não iniciada' if not_started?
    'Ativa'
  end

  def status_badge_class
    return 'bg-secondary' unless is_active?
    return 'bg-danger' if expired?
    return 'bg-warning' if not_started?
    'bg-success'
  end

  private

  def end_date_after_start_date
    return unless start_date && end_date
    
    if end_date < start_date
      errors.add(:end_date, 'deve ser posterior à data de início')
    end
  end

  def discount_value_within_limits
    return unless discount_value && discount_type
    
    if discount_type == 'percentage' && discount_value > 100
      errors.add(:discount_value, 'não pode ser maior que 100%')
    end
    
    if discount_type == 'fixed' && supplement && discount_value > supplement.price
      errors.add(:discount_value, 'não pode ser maior que o preço do produto')
    end
  end
end
