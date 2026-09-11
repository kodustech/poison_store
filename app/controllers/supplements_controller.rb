class SupplementsController < ApplicationController
  before_action :set_supplement, only: [:show, :edit, :update, :destroy]

  def index
    @supplements = Supplement.active.order(:name)
  end

  def show
  end

  def new
    @supplement = Supplement.new
  end

  def create
    @supplement = Supplement.new(supplement_params)
    
    if @supplement.save
      redirect_to @supplement, notice: 'Suplemento criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @supplement.update(supplement_params)
      redirect_to @supplement, notice: 'Suplemento atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @supplement.update(is_active: false)
    redirect_to supplements_path, notice: 'Suplemento desativado com sucesso!'
  end

  private

  def set_supplement
    @supplement = Supplement.find(params[:id])
  end

  def supplement_params
    params.require(:supplement).permit(
      :name, :supplement_type, :flavor, :weight, :protein_per_serving,
      :servings_per_container, :description, :nutritional_info,
      :usage_instructions, :price, :manufacturer, :stock_quantity, :minimum_stock
    )
  end
end
