class ReportsController < ApplicationController
  def index
    # Página inicial de relatórios
  end

  def top_medications
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.current.beginning_of_month
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.current.end_of_month
    @limit = params[:limit]&.to_i || 10

    @top_medications = generate_top_medications_report(@start_date, @end_date, @limit)
  end

  def search_doctors
    @crm_search = params[:crm_search]
    @doctors = []
    
    if @crm_search.present?
      @doctors = MedicalProfessional.where(crm: /#{@crm_search}/i)
    end
  end

  private

  def generate_top_medications_report(start_date, end_date, limit)
    # Buscar todas as vendas no período
    sales = MedicationSale.where(
      sale_date: start_date..end_date
    ).includes(:over_the_counter_medication)

    # Agrupar por medicamento e calcular estatísticas
    medication_stats = sales.group_by(&:over_the_counter_medication_id).map do |medication_id, medication_sales|
      medication = OverTheCounterMedication.find(medication_id)
      
      total_quantity = medication_sales.sum(&:quantity)
      total_revenue = medication_sales.sum(&:total_price)
      number_of_sales = medication_sales.count
      average_price = total_quantity > 0 ? (total_revenue / total_quantity) : 0.0
      
      # Calcular vendas com e sem receita
      with_prescription = medication_sales.select { |s| s.sold_with_prescription }.count
      without_prescription = medication_sales.select { |s| !s.sold_with_prescription }.count
      
      {
        medication_id: medication_id,
        medication_name: medication.name,
        total_quantity: total_quantity,
        total_revenue: total_revenue,
        number_of_sales: number_of_sales,
        average_price: average_price,
        with_prescription: with_prescription,
        without_prescription: without_prescription,
        total_sales: total_quantity # Mantido para compatibilidade com a view existente
      }
    end

    # Ordenar por quantidade vendida (descendente)
    sorted_medications = medication_stats.sort_by { |m| -m[:total_quantity] }
    
    # Aplicar limite se especificado
    limit > 0 ? sorted_medications.first(limit) : sorted_medications
  end
end
