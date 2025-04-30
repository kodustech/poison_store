class MedicationRequestsController < ApplicationController
  def new
    @medication_request = MedicationRequest.new
  end

  def create
    @medication_request = MedicationRequest.new(medication_request_params)
    
    if @medication_request.save
      redirect_to root_path, notice: 'Pedido de medicamento enviado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def medication_request_params
    params.require(:medication_request).permit(
      :name,
      :cpf,
      :address,
      :phone,
      :email,
      :monthly_income,
      :medication_name,
      :prescription_photo,
      :additional_info
    )
  end
end 