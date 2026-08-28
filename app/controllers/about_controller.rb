# Página institucional - informações sobre a farmácia
class AboutController < ApplicationController
  def index
    @store_name = 'Poison Store'
    @tagline = 'Sua farmácia de confiança'
    @services = [
      'Medicamentos com e sem prescrição',
      'Descontos para idosos e PCD',
      'Entrega e retirada no local'
    ]
  end
end
