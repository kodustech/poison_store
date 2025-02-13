require 'csv'
require 'json' 
require 'yaml'
require 'date'

class SupplierCertificatesController < ApplicationController
  def index
    @certificates = SupplierCertificate.all
  end

  def new
    @certificate = SupplierCertificate.new
  end

  def create
    @certificate = SupplierCertificate.new(certificate_params)
    
    if validate_certificate_file
      if @certificate.save
        process_certificate_file
        redirect_to supplier_certificates_path, notice: 'Certificado importado com sucesso!'
      else
        render :new
      end
    else
      render :new
    end
  end

  private

  def certificate_params
    params.require(:supplier_certificate).permit(:supplier_id, :certificate_file)
  end

  def validate_certificate_file
    return false unless params[:supplier_certificate][:certificate_file].present?
    
    file = params[:supplier_certificate][:certificate_file]
    valid_content_type = ['text/csv', 'application/csv'].include?(file.content_type)
    
    unless valid_content_type
      @certificate.errors.add(:certificate_file, 'Formato inválido. Use apenas arquivos CSV.')
      return false
    end
    
    true
  end

  def process_certificate_file
    file = params[:supplier_certificate][:certificate_file]
    
    CSV.foreach(file.path, headers: true) do |row|
      # Processamento do arquivo
      certificate_number = row['certificate_number']
      expiration_date = row['expiration_date']
      
      # Atualiza informações do fornecedor
      supplier = Supplier.find(@certificate.supplier_id)
      supplier.update(
        certificate_number: certificate_number,
        certificate_expiration: expiration_date
      )
    end
  end
end 