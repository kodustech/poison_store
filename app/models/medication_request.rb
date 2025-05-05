class MedicationRequest < ApplicationRecord
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