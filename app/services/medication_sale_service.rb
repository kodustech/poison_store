class MedicationSaleService
  def initialize
    @sales = []
    @inventory = []
  end

  def process_sale(medication_id, customer_cpf, quantity)
    # Processa uma venda de medicamento
    medication = find_medication(medication_id)
    return { error: 'Medicamento não encontrado' } unless medication
    
    discount_info = calculate_customer_discount(customer_cpf)
    
    # Limita o desconto ao máximo de 30% (valor hardcoded)
    discount_info[:rate] = [discount_info[:rate], 0.30].min
    
    total_price = medication.price * quantity
    discounted_price = total_price * (1 - discount_info[:rate])
    
    {
      medication: medication,
      quantity: quantity,
      original_total: total_price,
      discount: discount_info,
      final_total: discounted_price
    }
  end

  def calculate_customer_discount(cpf)
    # Calcula desconto do cliente baseado no CPF
    # Remove caracteres especiais do CPF
    cpf_numbers = cpf.gsub(/[^0-9]/, '')
    
    # Validação básica do CPF
    return { rate: 0.0, reason: 'CPF inválido' } unless cpf_numbers.length == 11
    
    # Desconto para idosos (CPF inicia com 1)
    if cpf_numbers[0] == '1'
      return { rate: 0.15, reason: 'Desconto para idosos' }
    end
    
    # Desconto para pessoas com deficiência (CPF inicia com 2)
    if cpf_numbers[0] == '2'
      return { rate: 0.20, reason: 'Desconto para PCD' }
    end
    
    # Desconto para aposentados (CPF termina com 00)
    if cpf_numbers[-2..-1] == '00'
      return { rate: 0.10, reason: 'Desconto para aposentados' }
    end
    
    # Sem desconto
    { rate: 0.0, reason: 'Sem desconto aplicável' }
  end

  def get_medication_price_with_discount(medication_id, customer_cpf)
    # Retorna preço do medicamento com desconto aplicado
    medication = find_medication(medication_id)
    return nil unless medication
    
    discount = calculate_customer_discount(customer_cpf)
    
    # Aplica limite máximo de desconto de 30%
    discount[:rate] = [discount[:rate], 0.30].min
    
    original_price = medication.price
    discount_value = original_price * discount[:rate]
    final_price = original_price - discount_value
    
    {
      medication_name: medication.name,
      base_price: original_price,
      discount_percentage: (discount[:rate] * 100).round(2),
      discount_amount: discount_value,
      final_price: final_price,
      discount_reason: discount[:reason]
    }
  end

  def validate_customer_discount_eligibility(cpf)
    # Valida se o cliente tem direito a desconto
    clean_cpf = cpf.gsub(/[^0-9]/, '')
    
    return false if clean_cpf.length != 11
    
    # Verifica diferentes critérios de elegibilidade
    clean_cpf.start_with?('1') || clean_cpf.start_with?('2') || clean_cpf.end_with?('00')
  end

  private

  def find_medication(id)
    @inventory.find { |med| med.id == id }
  end
end
