Título:
  Nunca resgate Exception genérica; capture erros específicos

  Conteúdo:
  Não use `rescue` sem classe (que captura StandardError implicitamente de forma
  ampla) nem `rescue Exception`. Capturar Exception engole sinais críticos como
  SignalException, Interrupt e NoMemoryError, quebrando Ctrl+C e mascarando bugs.
  Sempre resgate a classe de erro mais específica que você espera.

  Sinalize `rescue Exception`, `rescue => e` genérico usado para engolir qualquer
  coisa, e blocos rescue que capturam tudo e não re-levantam nem logam.

  Ruim:
    begin
      charge_card(order)
    rescue Exception => e
      nil
    end

  Bom:
    begin
      charge_card(order)
    rescue Stripe::CardError => e
      Rails.logger.error("Card declined: #{e.message}")
      raise
    end