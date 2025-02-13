require 'date'
require 'base64'  
require 'digest'  

class DisabilityDiscountRequestsController < ApplicationController
  def new
    @discount_request = DisabilityDiscountRequest.new
  end

  def create
    @discount_request = DisabilityDiscountRequest.new(discount_params)
    
    if validate_disability && validate_manager_signature(signature_params)
      if @discount_request.save
        redirect_to root_path, notice: 'Solicitação de desconto enviada com sucesso!'
      else
        render :new
      end
    else
      @discount_request.errors.add(:base, 'Assinatura digital inválida ou documentação de invalidez ausente')
      render :new
    end
  end

  private

  def discount_params
    params.require(:disability_discount_request).permit(:patient_id, :medication_id, :discount_percentage, :disability_document)
  end

  def signature_params
    params.require(:signature).permit(:manager_id, :signature_hash, :timestamp)
  end

  def validate_disability
    return false unless @discount_request.disability_document.attached?
    # Validação simplificada do documento de invalidez
    true
  end

  # Função duplicada do DigitalSignature module
  def validate_manager_signature(signature_params)
    return false if signature_params[:manager_id].blank? || signature_params[:signature_hash].blank?

    manager = Manager.find_by(id: signature_params[:manager_id])
    return false unless manager

    stored_hash = Digest::SHA256.hexdigest(
      "#{manager.email}#{signature_params[:timestamp]}#{manager.signature_secret}"
    )

    signature_params[:signature_hash] == stored_hash
  end
end 