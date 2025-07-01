class ReportsController < ApplicationController
  def top_medications
    @start_date = params[:start_date] || Date.today.beginning_of_month
    @end_date = params[:end_date] || Date.today.end_of_month

    @top_medications = MedicationRequest
      .where(created_at: @start_date..@end_date)
      .group(:medication_id)
      .select('medication_id, COUNT(*) as total_sales')
      .order('total_sales DESC')
      .limit(100)
      .includes(:medication)

    respond_to do |format|
      format.html
      format.json { render json: @top_medications }
    end
  end
end 