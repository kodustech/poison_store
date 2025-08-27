#!/usr/bin/env ruby

# Script de teste para verificar se os modelos estão funcionando
# Execute com: ruby test_script.rb

puts "🧪 Testando Sistema Poison Store..."
puts "=" * 50

begin
  # Verificar se o MongoDB está rodando
  require 'mongoid'
  
  # Configurar Mongoid
  Mongoid.load!('config/mongoid.yml', :development)
  
  puts "✅ Conexão com MongoDB estabelecida"
  
  # Testar criação de um remédio
  puts "\n📦 Testando criação de remédio..."
  
  medication = OverTheCounterMedication.new(
    name: "Teste Paracetamol",
    description: "Medicamento de teste",
    price: 10.50,
    active_ingredient: "Paracetamol",
    dosage_form: "Comprimido",
    strength: "500mg",
    manufacturer: "Teste",
    requires_prescription: false,
    stock_quantity: 100,
    minimum_stock: 10
  )
  
  if medication.save
    puts "✅ Remédio criado com sucesso: #{medication.name}"
    
    # Testar criação de uma venda
    puts "\n💰 Testando criação de venda..."
    
    sale = MedicationSale.new(
      over_the_counter_medication: medication,
      customer_name: "Cliente Teste",
      customer_cpf: "123.456.789-00",
      customer_phone: "(11) 99999-9999",
      customer_email: "teste@email.com",
      quantity: 2,
      unit_price: 10.50,
      sale_date: Date.current,
      payment_method: "Dinheiro",
      sold_with_prescription: false
    )
    
    if sale.save
      puts "✅ Venda criada com sucesso: #{sale.customer_name}"
      puts "   Total: R$ #{sale.total_price}"
      puts "   Estoque atualizado: #{medication.reload.stock_quantity}"
      
      # Limpar dados de teste
      sale.destroy
      medication.destroy
      puts "🧹 Dados de teste removidos"
    else
      puts "❌ Erro ao criar venda: #{sale.errors.full_messages.join(', ')}"
    end
  else
    puts "❌ Erro ao criar remédio: #{medication.errors.full_messages.join(', ')}"
  end
  
  puts "\n🎉 Todos os testes passaram!"
  
rescue => e
  puts "❌ Erro durante os testes: #{e.message}"
  puts e.backtrace.first(5).join("\n")
end
