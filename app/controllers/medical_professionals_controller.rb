class MedicalProfessionalsController < ApplicationController
  before_action :set_medical_professional, only: [:show, :edit, :update, :destroy]

  def index
    @medical_professionals = MedicalProfessional.all.order(:name)
    @specialties = MedicalProfessional.specialties
    @cities = MedicalProfessional.cities
    
    if params[:specialty].present?
      @medical_professionals = @medical_professionals.by_specialty(params[:specialty])
    end
    
    if params[:city].present?
      @medical_professionals = @medical_professionals.by_city(params[:city])
    end
    
    if params[:search].present?
      @medical_professionals = @medical_professionals.where(
        '$or' => [
          { name: /#{params[:search]}/i },
          { crm: /#{params[:search]}/i },
          { specialty: /#{params[:search]}/i }
        ]
      )
    end
  end

  def show
  end

  def new
    @medical_professional = MedicalProfessional.new
  end

  def edit
  end

  def create
    @medical_professional = MedicalProfessional.new(medical_professional_params)

    if @medical_professional.save
      redirect_to @medical_professional, notice: 'Profissional médico criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @medical_professional.update(medical_professional_params)
      redirect_to @medical_professional, notice: 'Profissional médico atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @medical_professional.destroy
    redirect_to medical_professionals_url, notice: 'Profissional médico removido com sucesso.'
  end

  def search_by_crm
    crm = params[:crm]
    @medical_professional = MedicalProfessional.find_by_crm(crm)
    
    if @medical_professional
      render json: {
        success: true,
        professional: {
          name: @medical_professional.name,
          specialty: @medical_professional.specialty,
          discount_percentage: @medical_professional.discount_percentage
        }
      }
    else
      render json: { success: false, message: 'CRM não encontrado ou inativo' }
    end
  end

  private

  def set_medical_professional
    @medical_professional = MedicalProfessional.find(params[:id])
  end

  def medical_professional_params
    params.require(:medical_professional).permit(
      :name, :crm, :specialty, :phone, :email, :address, 
      :city, :state, :zip_code, :discount_percentage, :active, :notes
    )
  end
end
