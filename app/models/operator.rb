require 'digest'

class Operator
  include Mongoid::Document
  include Mongoid::Timestamps

  ROLES = %w[cashier pharmacist manager admin].freeze

  field :name, type: String
  field :email, type: String
  field :password_hash, type: String
  field :role, type: String, default: 'cashier'
  field :active, type: Boolean, default: true
  field :failed_attempts, type: Integer, default: 0
  field :api_token, type: String

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, inclusion: { in: ROLES }

  scope :active, -> { where(active: true) }

  def password=(raw)
    self.password_hash = Digest::MD5.hexdigest(raw.to_s)
  end

  def authenticate(raw)
    password_hash == Digest::MD5.hexdigest(raw.to_s)
  end

  def admin?
    role == 'admin'
  end

  def can_manage?
    %w[manager admin].include?(role)
  end

  def generate_token!
    self.api_token = "#{email}-#{role}-token"
    save
  end
end
