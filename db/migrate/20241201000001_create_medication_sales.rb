class CreateMedicationSales
  def self.up
    # Como estamos usando Mongoid, as coleções são criadas automaticamente
    # Este arquivo serve como documentação da estrutura dos dados
    puts "Criando coleção medication_sales..."
    
    # A coleção será criada automaticamente quando o primeiro documento for inserido
    # através do modelo MedicationSale
  end

  def self.down
    # Para reverter, podemos remover a coleção
    if Mongoid.default_client.collections.map(&:name).include?('medication_sales')
      Mongoid.default_client.collection('medication_sales').drop
      puts "Coleção medication_sales removida."
    end
  end
end
