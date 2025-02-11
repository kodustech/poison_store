class Supplier
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :cpf, type: String
  field :email, type: String
  field :phone, type: String
  field :zip_code, type: String
  field :address, type: Hash

  has_and_belongs_to_many :potions

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
    
    response = HTTParty.get("https://viacep.com.br/ws/#{zip_code}/json/")
    if response.success?
      self.address = {
        street: response['logradouro'],
        neighborhood: response['bairro'],
        city: response['localidade'],
        state: response['uf']
      }
    end
  end
end 