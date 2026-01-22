class Laboratory
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :cnpj, type: String
  field :email, type: String
  field :phone, type: String
  field :contact_person, type: String
  field :zip_code, type: String
  field :address, type: Hash
  field :city, type: String
  field :state, type: String
  field :active, type: Boolean, default: true
  field :notes, type: String

  has_and_belongs_to_many :potions

  validates :name, :cnpj, presence: true
  validates :cnpj, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validate :validate_cnpj

  before_save :fetch_address, if: :zip_code_changed?

  def active?
    active == true
  end

  def full_address
    return nil unless address.present?
    
    parts = []
    parts << address['street'] if address['street'].present?
    parts << address['neighborhood'] if address['neighborhood'].present?
    parts << address['city'] if address['city'].present?
    parts << address['state'] if address['state'].present?
    
    parts.join(', ')
  end

  private

  def validate_cnpj
    return if cnpj.blank?
    unless CNPJ.valid?(cnpj)
      errors.add(:cnpj, "CNPJ inválido")
    end
  end

  def fetch_address
    return unless zip_code.present?
    
    begin
      response = HTTParty.get("https://viacep.com.br/ws/#{zip_code.gsub(/\D/, '')}/json/", timeout: 5)
      if response.success? && !response['erro']
        self.address = {
          street: response['logradouro'],
          neighborhood: response['bairro'],
          city: response['localidade'],
          state: response['uf']
        }
        self.city = response['localidade'] if city.blank?
        self.state = response['uf'] if state.blank?
      end
    rescue => e
      Rails.logger.error "Erro ao buscar CEP: #{e.message}"
    end
  end
end

