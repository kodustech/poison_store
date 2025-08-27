class AddDiscountFieldsToMedicationSales < Mongoid::Migration
  def self.up
    # Adicionar campos de desconto ao modelo MedicationSale
    # Como estamos usando Mongoid, os campos são definidos no modelo
    # Esta migração serve para documentar as mudanças
  end

  def self.down
    # Remover campos de desconto se necessário
  end
end
