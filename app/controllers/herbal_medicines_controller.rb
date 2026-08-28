class HerbalMedicinesController < ApplicationController
  before_action :set_herbal_medicine, only: [:show, :edit, :update, :destroy]

  def index
    @herbal_medicines = HerbalMedicine.active.order(:commercial_name)
  end

  def show
  end

  def new
    @herbal_medicine = HerbalMedicine.new
  end

  def create
    @herbal_medicine = HerbalMedicine.new(herbal_medicine_params)
    
    if @herbal_medicine.save
      redirect_to @herbal_medicine, notice: 'Remédio fitoterápico criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @herbal_medicine.update(herbal_medicine_params)
      redirect_to @herbal_medicine, notice: 'Remédio fitoterápico atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @herbal_medicine.update(is_active: false)
    redirect_to herbal_medicines_path, notice: 'Remédio fitoterápico desativado com sucesso!'
  end

  private

  def set_herbal_medicine
    @herbal_medicine = HerbalMedicine.find(params[:id])
  end

  def herbal_medicine_params
    params.require(:herbal_medicine).permit(
      :commercial_name, :scientific_name, :plant_part, :dosage_form,
      :description, :therapeutic_indications, :contraindications,
      :drug_interactions, :price, :manufacturer, :stock_quantity, :minimum_stock
    )
  end
end
