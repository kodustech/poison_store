class Customer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :cpf, type: String
  field :email, type: String
  field :phone, type: String
  field :zip_code, type: String
  field :address, type: Hash
  field :district, type: String
  field :city, type: String
  field :state, type: String
  field :address_number, type: String
  field :complement, type: String
  field :reference, type: String
  field :notes, type: String

  validates :name, :cpf, :email, presence: true
  validates :cpf, uniqueness: true
  validate :validate_cpf

  before_save :fetch_address

  private

  def validate_cpf
    unless CPF.valid?(cpf)
      errors.add(:cpf, "CPF inválido")
    end
  end

  def fetch_address
    return unless zip_code_changed?
    self.address = AddressUtils.fetch_address_by_zip_code(zip_code)
  end
end 