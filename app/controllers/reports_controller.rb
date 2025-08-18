class ReportsController < ApplicationController
  def index
    # Página principal dos relatórios
  end

  def top_medications
    @start_date = params[:start_date] || Date.today.beginning_of_month
    @end_date = params[:end_date] || Date.today.end_of_month

    @top_medications = MedicationRequest
      .where(created_at: @start_date..@end_date)
      .group_by(&:medication_name)
      .map do |medication_name, requests|
        {
          medication_name: medication_name,
          total_sales: requests.count,
          total_quantity: requests.sum(&:medication_quantity)
        }
      end
      .sort_by { |med| -med[:total_sales] }
      .first(100)

    respond_to do |format|
      format.html
      format.json { render json: @top_medications }
    end
  end

  def search_doctors
    @crm = params[:crm]
    
    if @crm.present?
      # Busca por CRM exato ou parcial usando regex do MongoDB
      regex = Regexp.new(@crm, Regexp::IGNORECASE)
      
      # Busca detalhada para estatísticas
      @doctor_details = MedicationRequest
        .where(doctor_crm: regex)
        .group_by(&:doctor_crm)
        .map do |crm, requests|
          {
            doctor_crm: crm,
            total_prescriptions: requests.count,
            unique_medications: requests.map(&:medication_name).uniq.count,
            active_days: requests.map { |r| r.created_at&.to_date }.compact.uniq.count,
            first_prescription: requests.map(&:created_at).compact.min,
            last_prescription: requests.map(&:created_at).compact.max
          }
        end
        .sort_by { |d| -d[:total_prescriptions] }
      
      @doctors = @doctor_details
    else
      @doctors = []
      @doctor_details = []
    end

    respond_to do |format|
      format.html
      format.json { render json: { doctors: @doctors, details: @doctor_details } }
    end
  end
end 