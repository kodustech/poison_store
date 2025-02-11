module AddressUtils
  def self.fetch_address_by_zip_code(zip_code)
    response = HTTParty.get("https://viacep.com.br/ws/#{zip_code}/json/")
    if response.success?
      {
        street: response['logradouro'],
        neighborhood: response['bairro'],
        city: response['localidade'],
        state: response['uf']
      }
    end
  end
end 