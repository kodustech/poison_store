require 'csv'

class MedicationBatchesController < ApplicationController
  before_action :set_medication, only: [:index, :new, :create]

  def index
    @batches = MedicationBatch.where(over_the_counter_medication: @medication).order(:expiration_date)
  end

  def new
    @batch = MedicationBatch.new
  end

  def create
    @batch = MedicationBatch.new(batch_params)
    @batch.over_the_counter_medication = @medication
    @batch.received_at = Time.current

    if @batch.save
      redirect_to medication_medication_batches_path(@medication), notice: 'Lote cadastrado.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def expiring
    @report = ExpirationService.expiring_report(params[:days].to_i)
    @days = params[:days].presence || 30

    respond_to do |format|
      format.html
      format.csv do
        send_data to_csv(@report), filename: "vencimentos-#{Date.current}.csv"
      end
    end
  end

  def quarantine_expired
    count = ExpirationService.quarantine_expired!
    redirect_to expiring_medication_batches_path, notice: "#{count} lotes colocados em quarentena."
  end

  private

  def to_csv(report)
    CSV.generate(headers: true) do |csv|
      csv << ['Medicamento', 'Lote', 'Quantidade', 'Validade', 'Dias restantes', 'Status']
      report.each do |item|
        csv << [item[:medication], item[:batch_number], item[:quantity], item[:expiration_date], item[:days_left], item[:status]]
      end
    end
  end

  def set_medication
    @medication = OverTheCounterMedication.find(params[:medication_id])
  end

  def batch_params
    params.require(:medication_batch).permit(
      :batch_number, :quantity, :manufacturing_date, :expiration_date, :supplier_name
    )
  end
end
