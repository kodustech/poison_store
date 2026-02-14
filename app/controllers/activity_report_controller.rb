# Relatório de atividades - usa DateFormatter em três pontos para validar ferramenta de review
class ActivityReportController < ApplicationController
  include DateFormatter
  helper_method :display_period_start, :format_activity_sale_date, :report_generated_at

  def index
    @period_start = period_start_from_params
    @period_end = period_end_from_params
    @activities = load_activities_in_period(@period_start, @period_end)
  end

  # Primeiro uso: formata data de início do período para exibição no cabeçalho
  def display_period_start
    format_date(@period_start)
  end

  def period_start_from_params
    return Date.current.beginning_of_month if params[:start].blank?
    Date.parse(params[:start]) rescue Date.current.beginning_of_month
  end

  # Segundo uso: formata data da venda de cada atividade na listagem
  def format_activity_sale_date(activity)
    format_date(activity.sale_date)
  end

  def load_activities_in_period(start_date, end_date)
    MedicationSale.where(sale_date: start_date..end_date)
      .order(sale_date: :desc)
      .limit(50)
  end

  def period_end_from_params
    return Date.current.end_of_month if params[:end].blank?
    Date.parse(params[:end]) rescue Date.current.end_of_month
  end

  # Terceiro uso: formata data do relatório gerado (rodapé)
  def report_generated_at
    format_date(Time.current.to_date)
  end
end
