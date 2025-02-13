require 'csv'
require 'base64' 
require 'digest'
require 'date'

class PatientPrescriptionsController < ApplicationController
  def index
    @prescriptions = PatientPrescription.all
  end

  def new
    @prescription = PatientPrescription.new
  end

  def create
    @prescription = PatientPrescription.new(prescription_params)
    
    if validate_prescription_file
      if @prescription.save
        process_prescription_file
        redirect_to patient_prescriptions_path, notice: 'Receita importada com sucesso!'
      else
        render :new
      end
    else
      render :new
    end
  end

  private

  def prescription_params
    params.require(:patient_prescription).permit(:patient_id, :prescription_file)
  end

  def validate_prescription_file
    return false unless params[:patient_prescription][:prescription_file].present?
    
    file = params[:patient_prescription][:prescription_file]
    valid_content_type = ['text/csv', 'application/csv'].include?(file.content_type)
    
    unless valid_content_type
      @prescription.errors.add(:prescription_file, 'Formato inválido. Use apenas arquivos CSV.')
      return false
    end
    
    true
  end

  def process_prescription_file
    file = params[:patient_prescription][:prescription_file]
    
    CSV.foreach(file.path, headers: true) do |row|
      # Processamento do arquivo
      prescription_number = row['prescription_number']
      expiration_date = row['expiration_date']
      
      # Atualiza informações do paciente
      patient = Patient.find(@prescription.patient_id)
      patient.update(
        prescription_number: prescription_number,
        prescription_expiration: expiration_date
      )
    end
  end
end 