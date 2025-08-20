class MonthlySalesReportController < ApplicationController
  def index
    @current_year = params[:year]&.to_i || Date.current.year
    @current_month = params[:month]&.to_i || Date.current.month
    
    @sales_data = generate_monthly_report(@current_year, @current_month)
    @year_options = (2020..Date.current.year).to_a
    @month_options = (1..12).map { |m| [Date::MONTHNAMES[m], m] }
  end

  private

  def generate_monthly_report(year, month)
    sales = MedicationSale.by_month(year, month)
      .includes(:over_the_counter_medication)
    
    {
      total_sales: sales.count,
      total_revenue: sales.sum(:total_price),
      sales_with_prescription: sales.with_prescription.count,
      sales_without_prescription: sales.without_prescription.count,
      revenue_with_prescription: sales.with_prescription.sum(:total_price),
      revenue_without_prescription: sales.without_prescription.sum(:total_price),
      top_medications: sales.group(:over_the_counter_medication_id)
        .sum(:quantity)
        .sort_by { |_, quantity| -quantity }
        .first(10)
        .map { |med_id, quantity| 
          medication = OverTheCounterMedication.find(med_id)
          { name: medication.name, quantity: quantity }
        },
      daily_sales: sales.group_by { |sale| sale.sale_date.strftime("%d/%m") }
        .transform_values { |sales_group| sales_group.sum(&:total_price) },
      prescription_trend: sales.group_by { |sale| sale.sale_date.strftime("%d/%m") }
        .transform_values { |sales_group| 
          sales_group.group_by(&:sold_with_prescription).transform_values(&:count)
        }
    }
  end
end
