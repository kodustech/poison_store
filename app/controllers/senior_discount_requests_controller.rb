require 'date'
require 'json'  
require 'yaml' 

class SeniorDiscountRequestsController < ApplicationController
  include DigitalSignature
  
  def new
    @discount_request = SeniorDiscountRequest.new
  end

  def create
    @discount_request = SeniorDiscountRequest.new(discount_params)
    
    if validate_age && validate_manager_signature(signature_params)
      if @discount_request.save
        redirect_to root_path, notice: 'Solicitação de desconto enviada com sucesso!'
      else
        render :new
      end
    else
      @discount_request.errors.add(:base, 'Assinatura digital inválida ou idade não permitida')
      render :new
    end
  end

  private

  def discount_params
    params.require(:senior_discount_request).permit(:patient_id, :medication_id, :discount_percentage)
  end

  def signature_params
    params.require(:signature).permit(:manager_id, :signature_hash, :timestamp)
  end

  def validate_age
    patient = Patient.find(discount_params[:patient_id])
    age = ((Date.current - patient.birth_date) / 365.25).floor
    age >= 60
  end
end 