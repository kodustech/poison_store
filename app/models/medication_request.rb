class MedicationRequest
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :cpf, type: String
  field :cep, type: String
  field :address, type: String
  field :address_number, type: String
  field :district, type: String
  field :city, type: String
  field :state, type: String
  field :phone, type: String
  field :email, type: String
  field :monthly_income, type: BigDecimal
  field :medication_name, type: String
  field :prescription_photo, type: String
  field :additional_info, type: String
  field :doctor_crm, type: String
  field :venous_application_notes, type: String
  field :medication_quantity, type: BigDecimal

  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true
  validates :address, presence: true
  validates :phone, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :monthly_income, presence: true, numericality: { greater_than: 0 }
  validates :medication_name, presence: true
  validates :prescription_photo, presence: true
  validates :doctor_crm, presence: true
  validates :medication_quantity, presence: true, numericality: { greater_than: 0 }
end 