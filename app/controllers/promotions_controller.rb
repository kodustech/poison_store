class PromotionsController < ApplicationController
  before_action :set_promotion, only: [:show, :edit, :update, :destroy]

  def index
    @promotions = Promotion.all.order(start_date: :desc)
  end

  def show
  end

  def new
    @promotion = Promotion.new
    @supplements = Supplement.active.order(:name)
    @promotion.start_date = Date.current
    @promotion.end_date = Date.current + 30.days
  end

  def create
    @promotion = Promotion.new(promotion_params)
    @supplements = Supplement.active.order(:name)
    
    if @promotion.save
      redirect_to @promotion, notice: 'Promoção criada com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @supplements = Supplement.active.order(:name)
  end

  def update
    @supplements = Supplement.active.order(:name)
    
    if @promotion.update(promotion_params)
      redirect_to @promotion, notice: 'Promoção atualizada com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @promotion.update(is_active: false)
    redirect_to promotions_path, notice: 'Promoção desativada com sucesso!'
  end

  private

  def set_promotion
    @promotion = Promotion.find(params[:id])
  end

  def promotion_params
    params.require(:promotion).permit(
      :name, :discount_type, :discount_value, :start_date, :end_date,
      :description, :supplement_id
    )
  end
end
