class CreateMedicationRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :medication_requests do |t|
      t.string :name, null: false
      t.string :cpf, null: false
      t.text :address, null: false
      t.string :phone, null: false
      t.string :email, null: false
      t.decimal :monthly_income, null: false, precision: 10, scale: 2
      t.string :medication_name, null: false
      t.string :prescription_photo, null: false
      t.text :additional_info

      t.timestamps
    end

    add_index :medication_requests, :cpf, unique: true
  end
end 