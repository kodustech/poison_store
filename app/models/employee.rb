class Employee
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :cpf, type: String
  field :email, type: String
  field :phone, type: String
  field :address, type: String
  field :city, type: String
  field :state, type: String
  field :zip_code, type: String
  field :department, type: String
  field :role, type: String
  field :salary, type: Float
  field :hire_date, type: Date
  field :status, type: String
  field :created_at, type: DateTime
  field :updated_at, type: DateTime
end