class ReportsController < ApplicationController
  def index
  end

  def top_medications
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : 30.days.ago.to_date
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.current
    @limit = params[:limit].present? ? params[:limit].to_i : 10

    # Buscar medicamentos mais vendidos no período usando Mongoid
    pipeline = [
      {
        '$match' => {
          'created_at' => {
            '$gte' => @start_date.beginning_of_day,
            '$lte' => @end_date.end_of_day
          }
        }
      },
      {
        '$group' => {
          '_id' => '$medication_name',
          'total_sales' => { '$sum' => 1 },
          'total_quantity' => { '$sum' => '$medication_quantity' }
        }
      },
      {
        '$sort' => {
          'total_sales' => -1,
          'total_quantity' => -1
        }
      }
    ]

    # Aplicar limit apenas se não for 0 (todos)
    pipeline << { '$limit' => @limit } if @limit > 0

    @top_medications = MedicationRequest.collection.aggregate(pipeline).map do |doc|
      {
        medication_name: doc['_id'],
        total_sales: doc['total_sales'],
        total_quantity: doc['total_quantity']
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: @top_medications }
    end
  end

  def search_doctors
    @crm = params[:crm]
    
    if @crm.present?
      pipeline = [
        {
          '$match' => {
            'doctor_crm' => { '$regex' => @crm, '$options' => 'i' }
          }
        },
        {
          '$group' => {
            '_id' => '$doctor_crm',
            'total_prescriptions' => { '$sum' => 1 },
            'unique_medications' => { '$addToSet' => '$medication_name' }
          }
        }
      ]

      @doctor_details = MedicationRequest.collection.aggregate(pipeline).map do |doctor|
        prescriptions = MedicationRequest.where(doctor_crm: doctor['_id'])
        {
          doctor_crm: doctor['_id'],
          total_prescriptions: doctor['total_prescriptions'],
          unique_medications: doctor['unique_medications'].count,
          active_days: prescriptions.distinct(:created_at).count,
          first_prescription: prescriptions.min(:created_at),
          last_prescription: prescriptions.max(:created_at)
        }
      end
    end

    respond_to do |format|
      format.html
      format.json { render json: @doctor_details }
    end
  end
end
