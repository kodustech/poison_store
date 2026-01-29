class Promo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :code, type: String
  field :discount, type: Float
  field :expiration_date, type: DateTime
  field :created_at, type: DateTime
  field :updated_at, type: DateTime
end