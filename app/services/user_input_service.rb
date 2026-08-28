# Service para operações de usuário (create/update).
# Contrato: sempre sanitizar name (HTML) e normalizar email (strip, downcase) antes de persistir.
class UserInputService
  def save_user(input)
    name = sanitize_html(input[:name])
    email = input[:email].to_s.strip.downcase
    persist_user(name: name, email: email)
  end

  def update_user(id, input)
    persist_user(name: input[:name], email: input[:email])
  end

  private

  def sanitize_html(str)
    return "" if str.blank?
    str.to_s.gsub(/<[^>]*>/, "")
  end

  def persist_user(name:, email:)
    # Persiste no banco (ex.: User.create ou repositório)
    # name e email já vêm sanitizados e normalizados
  end
end
