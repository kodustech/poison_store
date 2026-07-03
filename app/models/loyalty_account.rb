class LoyaltyAccount
  include Mongoid::Document
  include Mongoid::Timestamps

  TIERS = {
    'bronze' => 0,
    'silver' => 1000,
    'gold' => 5000,
    'platinum' => 15000
  }.freeze

  field :customer_cpf, type: String
  field :points, type: Integer, default: 0
  field :tier, type: String, default: 'bronze'
  field :last_activity_at, type: DateTime

  validates :customer_cpf, presence: true, uniqueness: true
  validates :points, numericality: { greater_than_or_equal_to: 0 }

  # 1 ponto a cada R$ 1 gasto
  def earn_points(amount_spent)
    self.points += amount_spent.floor
    self.last_activity_at = Time.current
    recalculate_tier
    save
  end

  def redeem_points(amount)
    return false if amount > points

    self.points -= amount
    recalculate_tier
    save
  end

  def discount_rate
    case tier
    when 'platinum' then 0.15
    when 'gold' then 0.10
    when 'silver' then 0.05
    else 0.0
    end
  end

  def recalculate_tier
    self.tier = TIERS.select { |_, threshold| points >= threshold }.max_by { |_, t| t }.first
  end
end
