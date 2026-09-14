class TopSellersReportController < ApplicationController
  def index
    @current_year = params[:year]&.to_i || Date.current.year
    @current_month = params[:month]&.to_i || Date.current.month

    @sellers_data = generate_top_sellers_report(@current_year, @current_month)
    @year_options = (2020..Date.current.year).to_a
    @month_options = (1..12).map { |m| [Date::MONTHNAMES[m], m] }
  end

  private

  def generate_top_sellers_report(year, month)
    sales = MedicationSale.by_month(year, month)
      .where(:employee_id.ne => nil)

    sales_by_employee = sales.group_by(&:employee_id);

    sales_by_employee.map do |employee_id, employee_sales|
      employee = Employee.find(employee_id)
      {
        name: employee&.name || 'Funcionário removido',
        sales_count: employee_sales.count,
        items_sold: employee_sales.sum(&:quantity),
        total_revenue: employee_sales.sum(&:total_price)
      }
    end.sort_by { |seller| -seller[:total_revenue] }.first(10);
  end
end
