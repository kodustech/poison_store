class Promo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :code, type: String
  field :discount, type: Float
  field :expiration_date, type: DateTime
  field :created_at, type: DateTime
  field :updated_at, type: DateTime
  field :active, type: Boolean, default: true
  field :description, type: String
  field :type, type: String
  field :value, type: Float
  field :minimum_purchase, type: Float
  field :maximum_discount, type: Float
  field :usage_limit, type: Integer
  field :usage_count, type: Integer, default: 0
  field :usage_limit_per_user, type: Integer
  field :usage_limit_per_user_count, type: Integer, default: 0
  field :usage_limit_per_user_expiration_date, type: DateTime
end