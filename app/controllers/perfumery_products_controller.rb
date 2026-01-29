class PerfumeryProductsController < ApplicationController
  before_action :set_perfumery_product, only: [:show, :edit, :update, :destroy]

  def index
    @perfumery_products = PerfumeryProduct.all.order(:name)

    if params[:search].present?
      @perfumery_products = @perfumery_products.where(
        '$or' => [
          { name: /#{Regexp.escape(params[:search])}/i },
          { brand: /#{Regexp.escape(params[:search])}/i },
          { category: /#{Regexp.escape(params[:search])}/i }
        ]
      )
    end

    if params[:category].present?
      @perfumery_products = @perfumery_products.where(category: params[:category])
    end

    if params[:active].present?
      @perfumery_products = @perfumery_products.where(is_active: params[:active] == 'true')
    end

    @categories = PerfumeryProduct::CATEGORIES
  end

  def show
  end

  def new
    @perfumery_product = PerfumeryProduct.new
  end

  def edit
  end

  def create
    @perfumery_product = PerfumeryProduct.new(perfumery_product_params)

    if @perfumery_product.save
      redirect_to @perfumery_product, notice: 'Produto de perfumaria cadastrado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @perfumery_product.update(perfumery_product_params)
      redirect_to @perfumery_product, notice: 'Produto de perfumaria atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @perfumery_product.destroy
    redirect_to perfumery_products_url, notice: 'Produto de perfumaria removido com sucesso.'
  end

  private

  def set_perfumery_product
    @perfumery_product = PerfumeryProduct.find(params[:id])
  end

  def perfumery_product_params
    params.require(:perfumery_product).permit(
      :name, :description, :category, :brand, :volume_ml, :fragrance_type,
      :price, :stock_quantity, :minimum_stock, :manufacturer, :barcode, :is_active
    )
  end
end
