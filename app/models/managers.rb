class Managers
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String
  field :password, type: String
  field :created_at, type: DateTime
  field :updated_at, type: DateTime

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  has_secure_password
end