class RestockOrder
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUSES = %w[draft submitted received cancelled].freeze

  field :status, type: String, default: 'draft'
  field :supplier_name, type: String
  field :expected_delivery, type: Date
  field :notes, type: String
  field :total_amount, type: Float, default: 0.0

  belongs_to :over_the_counter_medication
  belongs_to :supplier, optional: true

  field :requested_quantity, type: Integer
  field :received_quantity, type: Integer, default: 0
  field :unit_cost, type: Float

  validates :status, inclusion: { in: STATUSES }
  validates :supplier_name, presence: true
  validates :requested_quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_cost, presence: true, numericality: { greater_than: 0 }

  scope :pending, -> { where(:status.in => %w[draft submitted]) }
  scope :received, -> { where(status: 'received') }

  before_save :recalculate_total

  def submit!
    update(status: 'submitted')
  end

  def receive!(quantity)
    self.received_quantity = quantity
    self.status = 'received'
    save
  end

  def outstanding_quantity
    requested_quantity - received_quantity
  end

  def fully_received?
    received_quantity >= requested_quantity
  end

  private

  def recalculate_total
    self.total_amount = requested_quantity.to_i * unit_cost.to_f
  end
end
