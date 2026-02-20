# Service para chamadas à API de usuários.
# Contrato: sempre usar encode no id na URL e tratar erro com AppError + parse_error_body.
class UserApiService
  BASE_URL = "https://api.example.com/users"

  # Trecho A — já existia: estabelece o padrão de encode e error handling
  def get_user(id)
    encoded_id = ERB::Util.url_encode(id)
    res = HTTParty.get("#{BASE_URL}/#{encoded_id}")
    unless res.success?
      raise AppError.new(res.code, parse_error_body(res))
    end
    res.parsed_response
  end

  # Trecho B — adicionado no PR: sem encode no id (path traversal), erro genérico (quebra o contrato)
  def delete_user(id)
    res = HTTParty.delete("#{BASE_URL}/#{id}")
    unless res.success?
      raise StandardError, "Failed: #{res.code}"
    end
    res.parsed_response
  end

  private

  def parse_error_body(res)
    body = res.respond_to?(:body) ? res.body : res
    JSON.parse(body.to_s)
  rescue JSON::ParserError
    { "message" => body.to_s }
  end
end

# Erro de aplicação com status e body parseado (contrato do service)
class AppError < StandardError
  attr_reader :status, :body

  def initialize(status, body)
    @status = status
    @body = body
    super("Request failed: #{status}")
  end
end
