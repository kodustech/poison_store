class CreateOverTheCounterMedications
  def self.up
    # Como estamos usando Mongoid, as coleções são criadas automaticamente
    # Este arquivo serve como documentação da estrutura dos dados
    puts "Criando coleção over_the_counter_medications..."
    
    # A coleção será criada automaticamente quando o primeiro documento for inserido
    # através do modelo OverTheCounterMedication
  end

  def self.down
    # Para reverter, podemos remover a coleção
    if Mongoid.default_client.collections.map(&:name).include?('over_the_counter_medications')
      Mongoid.default_client.collection('over_the_counter_medications').drop
      puts "Coleção over_the_counter_medications removida."
    end
  end
end
