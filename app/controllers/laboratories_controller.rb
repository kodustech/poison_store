class LaboratoriesController < ApplicationController
  before_action :set_laboratory, only: [:show, :edit, :update, :destroy]

  def index
    @laboratories = Laboratory.all.order(:name)
    
    if params[:search].present?
      @laboratories = @laboratories.where(
        '$or' => [
          { name: /#{params[:search]}/i },
          { cnpj: /#{params[:search]}/i },
          { city: /#{params[:search]}/i }
        ]
      )
    end

    if params[:state].present?
      @laboratories = @laboratories.where(state: params[:state])
    end

    if params[:active].present?
      @laboratories = @laboratories.where(active: params[:active] == 'true')
    end

    @states = Laboratory.distinct(:state).compact.sort
  end

  def show
  end

  def new
    @laboratory = Laboratory.new
  end

  def edit
  end

  def create
    @laboratory = Laboratory.new(laboratory_params)

    if @laboratory.save
      redirect_to @laboratory, notice: 'Laboratório criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @laboratory.update(laboratory_params)
      redirect_to @laboratory, notice: 'Laboratório atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @laboratory.destroy
    redirect_to laboratories_url, notice: 'Laboratório removido com sucesso.'
  end

  private

  def set_laboratory
    @laboratory = Laboratory.find(params[:id])
  end

  def laboratory_params
    params.require(:laboratory).permit(
      :name, :cnpj, :email, :phone, :contact_person, 
      :zip_code, :city, :state, :active, :notes
    )
  end
end

