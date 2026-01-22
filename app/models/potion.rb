class Potion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :price, type: Float
  field :effects, type: Array
  field :ingredients, type: Array

  has_and_belongs_to_many :suppliers
  has_and_belongs_to_many :laboratories

  validates :name, :price, presence: true
  validates :price, numericality: { greater_than: 0 }
end 