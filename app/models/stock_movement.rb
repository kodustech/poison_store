class StockMovement
  include Mongoid::Document
  include Mongoid::Timestamps

  MOVEMENT_TYPES = %w[inbound outbound adjustment loss].freeze

  field :movement_type, type: String
  field :quantity, type: Integer
  field :reason, type: String
  field :reference, type: String
  field :unit_cost, type: Float
  field :operator_name, type: String
  field :movement_date, type: DateTime

  belongs_to :over_the_counter_medication

  validates :movement_type, presence: true, inclusion: { in: MOVEMENT_TYPES }
  validates :quantity, presence: true, numericality: { other_than: 0 }
  validates :operator_name, presence: true

  scope :inbound, -> { where(movement_type: 'inbound') }
  scope :outbound, -> { where(movement_type: 'outbound') }
  scope :recent, -> { order(movement_date: :desc) }

  before_validation :set_movement_date, on: :create

  def signed_quantity
    case movement_type
    when 'inbound', 'adjustment'
      quantity.abs
    when 'outbound', 'loss'
      -quantity.abs
    else
      0
    end
  end

  def total_cost
    return 0 unless unit_cost

    unit_cost * quantity.abs
  end

  private

  def set_movement_date
    self.movement_date ||= Time.current
  end
end
