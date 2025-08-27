class MedicationSalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]

  def index
    @sales = MedicationSale.includes(:over_the_counter_medication).order(sale_date: :desc)
  end

  def show
  end

  def new
    @sale = MedicationSale.new
    @medications = OverTheCounterMedication.active.in_stock
  end

  def create
    @sale = MedicationSale.new(sale_params)
    @sale.sale_date = Date.current if @sale.sale_date.blank?
    
    # Aplicar desconto médico se aplicável
    if @sale.sold_with_prescription && @sale.doctor_crm.present?
      MedicalDiscountService.apply_discount_to_sale(@sale)
    end
    
    if @sale.save
      redirect_to @sale, notice: 'Venda registrada com sucesso!'
    else
      @medications = OverTheCounterMedication.active.in_stock
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @medications = OverTheCounterMedication.active.in_stock
  end

  def update
    if @sale.update(sale_params)
      # Recalcular desconto médico se aplicável
      if @sale.sold_with_prescription && @sale.doctor_crm.present?
        MedicalDiscountService.apply_discount_to_sale(@sale)
        @sale.save
      end
      
      redirect_to @sale, notice: 'Venda atualizada com sucesso!'
    else
      @medications = OverTheCounterMedication.active.in_stock
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sale.destroy
    redirect_to medication_sales_path, notice: 'Venda removida com sucesso!'
  end

  private

  def set_sale
    @sale = MedicationSale.find(params[:id])
  end

  def sale_params
    params.require(:medication_sale).permit(
      :over_the_counter_medication_id, :customer_name, :customer_cpf, :customer_phone,
      :customer_email, :quantity, :unit_price, :sold_with_prescription,
      :prescription_reference, :doctor_name, :doctor_crm, :sale_date,
      :payment_method, :notes
    )
  end
end
