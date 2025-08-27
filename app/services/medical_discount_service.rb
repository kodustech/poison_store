class MedicalDiscountService
  def initialize(doctor_crm, prescription_present = false)
    @doctor_crm = doctor_crm
    @prescription_present = prescription_present
    @medical_professional = nil
  end

  def valid_for_discount?
    return false unless @prescription_present
    return false if @doctor_crm.blank?
    
    @medical_professional = MedicalProfessional.find_by_crm(@doctor_crm)
    @medical_professional&.active?
  end

  def discount_percentage
    return 0.0 unless valid_for_discount?
    @medical_professional.discount_percentage
  end

  def discount_amount(original_price)
    return 0.0 unless valid_for_discount?
    (original_price * discount_percentage / 100.0).round(2)
  end

  def final_price(original_price)
    return original_price unless valid_for_discount?
    (original_price - discount_amount(original_price)).round(2)
  end

  def professional_info
    return nil unless valid_for_discount?
    {
      name: @medical_professional.name,
      specialty: @medical_professional.specialty,
      crm: @medical_professional.crm,
      discount_percentage: @medical_professional.discount_percentage
    }
  end

  def validation_message
    if @doctor_crm.blank?
      "CRM do médico é obrigatório para aplicar desconto"
    elsif !@prescription_present
      "Receita médica é obrigatória para aplicar desconto"
    elsif @medical_professional.nil?
      "CRM não encontrado no sistema"
    elsif !@medical_professional.active?
      "Profissional médico inativo - não pode gerar desconto"
    else
      "Desconto válido"
    end
  end

  def self.validate_crm_format(crm)
    return false if crm.blank?
    crm.match?(/\A\d{2,10}\z/)
  end

  def self.search_professional_by_crm(crm)
    return nil unless validate_crm_format(crm)
    MedicalProfessional.find_by_crm(crm)
  end

  def self.apply_discount_to_sale(sale)
    service = new(sale.doctor_crm, sale.sold_with_prescription)
    
    if service.valid_for_discount?
      sale.discount_percentage = service.discount_percentage
      sale.discount_applied = service.discount_amount(sale.original_price)
      sale.final_price = service.final_price(sale.original_price)
      sale.total_price = sale.final_price
    else
      sale.discount_percentage = 0.0
      sale.discount_applied = 0.0
      sale.final_price = sale.original_price
      sale.total_price = sale.original_price
    end
    
    sale
  end
end
