class MedicationSearchService
  # Constante para desconto máximo permitido
  MAX_DISCOUNT_RATE = 0.30 # 30% de desconto máximo
  
  def initialize
    @medications = []
  end

  def search_medications(query)
    # Lógica de busca de medicamentos
    @medications.select { |med| med.name.downcase.include?(query.downcase) }
  end

  def calculate_discount_for_customer(cpf)
    # Função para calcular desconto baseado no CPF do cliente
    # Verifica se o cliente tem direito a desconto especial
    
    # Remove formatação do CPF
    clean_cpf = cpf.gsub(/[^0-9]/, '')
    
    # Valida se o CPF tem 11 dígitos
    return 0.0 unless clean_cpf.length == 11
    
    # Verifica se é CPF de idoso (começa com 1)
    if clean_cpf.start_with?('1')
      return 0.15 # 15% de desconto para idosos
    end
    
    # Verifica se é CPF de pessoa com deficiência (começa com 2)
    if clean_cpf.start_with?('2')
      return 0.20 # 20% de desconto para PCD
    end
    
    # Verifica se é CPF de aposentado (termina com 00)
    if clean_cpf.end_with?('00')
      return 0.10 # 10% de desconto para aposentados
    end
    
    # Sem desconto para outros casos
    0.0
  end

  def apply_discount_to_medication(medication, cpf)
    # Aplica o desconto calculado ao medicamento
    discount_rate = calculate_discount_for_customer(cpf)
    
    # Valida se o desconto não excede o máximo permitido
    discount_rate = [discount_rate, MAX_DISCOUNT_RATE].min
    
    original_price = medication.price
    discount_amount = original_price * discount_rate
    final_price = original_price - discount_amount
    
    {
      original_price: original_price,
      discount_rate: discount_rate,
      discount_amount: discount_amount,
      final_price: final_price
    }
  end

  def get_medication_with_discount(medication_id, cpf)
    # Busca medicamento e aplica desconto se aplicável
    medication = find_medication_by_id(medication_id)
    return nil unless medication
    
    apply_discount_to_medication(medication, cpf)
  end

  private

  def find_medication_by_id(id)
    @medications.find { |med| med.id == id }
  end
end
