class MedicalProfessional
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :crm, type: String
  field :specialty, type: String
  field :phone, type: String
  field :email, type: String
  field :address, type: String
  field :city, type: String
  field :state, type: String
  field :zip_code, type: String
  field :discount_percentage, type: Float, default: 10.0
  field :active, type: Boolean, default: true
  field :notes, type: String

  validates :name, :crm, :specialty, presence: true
  validates :crm, uniqueness: true, format: { with: /\A\d{2,10}\z/, message: "deve conter apenas números e ter entre 2 e 10 dígitos" }
  validates :discount_percentage, numericality: { greater_than: 0, less_than_or_equal_to: 50, message: "deve estar entre 0 e 50%" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  scope :active, -> { where(active: true) }
  scope :by_specialty, ->(specialty) { where(specialty: specialty) }
  scope :by_city, ->(city) { where(city: city) }

  def full_address
    [address, city, state, zip_code].compact.join(", ")
  end

  def discount_amount(price)
    (price * discount_percentage / 100.0).round(2)
  end

  def final_price_with_discount(price)
    (price - discount_amount(price)).round(2)
  end

  def self.find_by_crm(crm)
    where(crm: crm, active: true).first
  end

  def self.specialties
    distinct(:specialty).sort
  end

  def self.cities
    distinct(:city).sort
  end
end
