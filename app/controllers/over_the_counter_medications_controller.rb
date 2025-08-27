class OverTheCounterMedicationsController < ApplicationController
  before_action :set_medication, only: [:show, :edit, :update, :destroy]

  def index
    @medications = OverTheCounterMedication.active.order(:name)
  end

  def show
  end

  def new
    @medication = OverTheCounterMedication.new
  end

  def create
    @medication = OverTheCounterMedication.new(medication_params)
    
    if @medication.save
      redirect_to @medication, notice: 'Medicamento criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @medication.update(medication_params)
      redirect_to @medication, notice: 'Medicamento atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @medication.update(is_active: false)
    redirect_to over_the_counter_medications_path, notice: 'Medicamento desativado com sucesso!'
  end

  private

  def set_medication
    @medication = OverTheCounterMedication.find(params[:id])
  end

  def medication_params
    params.require(:over_the_counter_medication).permit(
      :name, :description, :price, :active_ingredient, :dosage_form,
      :strength, :manufacturer, :requires_prescription, :stock_quantity, :minimum_stock
    )
  end
end
