require 'csv'
require 'date'

class AccountsReceivableReportController < ApplicationController
  include DateFormatter

  def index
    @accounts_receivable = AccountReceivable.all
    respond_to do |format|
      format.html
      format.csv { send_data generate_csv, filename: "contas_a_receber_#{Time.current.to_i}.csv" }
    end
  end

  private

  def generate_csv
    CSV.generate(headers: true) do |csv|
      csv << ['Cliente', 'Valor', 'Vencimento', 'Status']
      
      @accounts_receivable.each do |account|
        csv << [
          account.customer.name,
          format_currency(account.amount),
          format_date(account.due_date),
          account.status
        ]
      end
    end
  end

  def format_currency(value)
    return 'R$ 0,00' if value.nil?
    
    # Função duplicada de formatação monetária
    formatted = '%.2f' % value
    formatted.gsub!('.', ',')
    "R$ #{formatted}"
  end
end 