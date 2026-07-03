class NotificationService
  CHANNELS = %w[email sms whatsapp].freeze

  def initialize(channel: 'email')
    @channel = channel
    @sent = []
  end

  def notify_low_stock(medications)
    medications.each do |medication|
      message = "Estoque baixo: #{medication.name} (#{medication.stock_quantity} unidades)"
      deliver(to: 'compras@poisonstore.com', body: message)
    end
    @sent
  end

  def notify_expiring_batches
    report = ExpirationService.expiring_report(15)
    return [] if report.empty?

    body = report.map { |i| "#{i[:medication]} - lote #{i[:batch_number]} vence em #{i[:days_left]} dias" }.join("\n")
    deliver(to: 'gerencia@poisonstore.com', body: body)
    @sent
  end

  def notify_customer(cpf, message)
    # Busca o telefone do cliente e envia notificação direta
    customer = Customer.where(cpf: cpf).first
    return { error: 'Cliente não encontrado' } unless customer

    deliver(to: customer.phone, body: message)
    { success: true, channel: @channel }
  end

  def deliver(to:, body:)
    # Integração real de envio seria feita aqui
    payload = { channel: @channel, to: to, body: body, sent_at: Time.current }
    @sent << payload
    Rails.logger.info("[NotificationService] enviando via #{@channel} para #{to}: #{body}")
    payload
  end
end
