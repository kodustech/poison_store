# Seeds para Remédios Não Controlados
puts "Criando remédios não controlados..."

# Remédios que NÃO requerem receita
medications_without_prescription = [
  {
    name: "Paracetamol 500mg",
    description: "Analgésico e antitérmico para alívio de dores e febre",
    price: 8.50,
    active_ingredient: "Paracetamol",
    dosage_form: "Comprimido",
    strength: "500mg",
    manufacturer: "Genérico",
    requires_prescription: false,
    stock_quantity: 150,
    minimum_stock: 20
  },
  {
    name: "Dipirona 500mg",
    description: "Analgésico e antitérmico para dores moderadas",
    price: 6.80,
    active_ingredient: "Dipirona",
    dosage_form: "Comprimido",
    strength: "500mg",
    manufacturer: "Genérico",
    requires_prescription: false,
    stock_quantity: 120,
    minimum_stock: 15
  },
  {
    name: "Ibuprofeno 600mg",
    description: "Anti-inflamatório não esteroidal para dores e inflamações",
    price: 12.90,
    active_ingredient: "Ibuprofeno",
    dosage_form: "Comprimido",
    strength: "600mg",
    manufacturer: "Genérico",
    requires_prescription: false,
    stock_quantity: 80,
    minimum_stock: 10
  },
  {
    name: "Omeprazol 20mg",
    description: "Protetor gástrico para azia e refluxo",
    price: 15.75,
    active_ingredient: "Omeprazol",
    dosage_form: "Cápsula",
    strength: "20mg",
    manufacturer: "Genérico",
    requires_prescription: false,
    stock_quantity: 95,
    minimum_stock: 12
  },
  {
    name: "Vitamina C 1000mg",
    description: "Suplemento vitamínico para fortalecimento do sistema imunológico",
    price: 22.50,
    active_ingredient: "Ácido Ascórbico",
    dosage_form: "Comprimido",
    strength: "1000mg",
    manufacturer: "Genérico",
    requires_prescription: false,
    stock_quantity: 200,
    minimum_stock: 25
  }
]

# Remédios que REQUEREM receita
medications_with_prescription = [
  {
    name: "Amoxicilina 500mg",
    description: "Antibiótico para tratamento de infecções bacterianas",
    price: 28.90,
    active_ingredient: "Amoxicilina",
    dosage_form: "Cápsula",
    strength: "500mg",
    manufacturer: "Genérico",
    requires_prescription: true,
    stock_quantity: 60,
    minimum_stock: 8
  },
  {
    name: "Losartana 50mg",
    description: "Anti-hipertensivo para controle da pressão arterial",
    price: 18.75,
    active_ingredient: "Losartana",
    dosage_form: "Comprimido",
    strength: "50mg",
    manufacturer: "Genérico",
    requires_prescription: true,
    stock_quantity: 45,
    minimum_stock: 6
  }
]

# Criar remédios sem receita obrigatória
medications_without_prescription.each do |med_data|
  medication = OverTheCounterMedication.find_or_create_by(name: med_data[:name]) do |med|
    med.assign_attributes(med_data)
  end
  puts "✓ #{medication.name} - #{medication.requires_prescription? ? 'Com Receita' : 'Sem Receita'}"
end

# Criar remédios com receita obrigatória
medications_with_prescription.each do |med_data|
  medication = OverTheCounterMedication.find_or_create_by(name: med_data[:name]) do |med|
    med.assign_attributes(med_data)
  end
  puts "✓ #{medication.name} - #{medication.requires_prescription? ? 'Com Receita' : 'Sem Receita'}"
end

puts "\nRemédios criados com sucesso!"
puts "Total: #{OverTheCounterMedication.count} medicamentos cadastrados"
puts "Sem receita: #{OverTheCounterMedication.no_prescription_required.count}"
puts "Com receita: #{OverTheCounterMedication.requires_prescription.count}"

# Seeds para Profissionais Médicos
puts "\nCriando profissionais médicos..."

medical_professionals = [
  {
    name: "Dr. Carlos Eduardo Silva",
    crm: "12345",
    specialty: "Cardiologia",
    phone: "(11) 99999-1111",
    email: "carlos.silva@cardio.com.br",
    address: "Rua das Flores, 123",
    city: "São Paulo",
    state: "SP",
    zip_code: "01234-567",
    discount_percentage: 15.0,
    active: true,
    notes: "Especialista em cardiologia intervencionista"
  },
  {
    name: "Dra. Ana Paula Santos",
    crm: "67890",
    specialty: "Pediatria",
    phone: "(11) 99999-2222",
    email: "ana.santos@pediatria.com.br",
    address: "Av. Paulista, 456",
    city: "São Paulo",
    state: "SP",
    zip_code: "01310-100",
    discount_percentage: 12.5,
    active: true,
    notes: "Pediatra com especialização em neonatologia"
  },
  {
    name: "Dr. Roberto Mendes",
    crm: "11111",
    specialty: "Ortopedia",
    phone: "(11) 99999-3333",
    email: "roberto.mendes@orto.com.br",
    address: "Rua Augusta, 789",
    city: "São Paulo",
    state: "SP",
    zip_code: "01212-000",
    discount_percentage: 10.0,
    active: true,
    notes: "Especialista em cirurgia do joelho e quadril"
  },
  {
    name: "Dra. Fernanda Costa",
    crm: "22222",
    specialty: "Dermatologia",
    phone: "(11) 99999-4444",
    email: "fernanda.costa@derma.com.br",
    address: "Rua Oscar Freire, 321",
    city: "São Paulo",
    state: "SP",
    zip_code: "01426-000",
    discount_percentage: 8.0,
    active: true,
    notes: "Dermatologista especializada em estética"
  },
  {
    name: "Dr. Marcelo Oliveira",
    crm: "33333",
    specialty: "Neurologia",
    phone: "(11) 99999-5555",
    email: "marcelo.oliveira@neuro.com.br",
    address: "Av. Brigadeiro Faria Lima, 654",
    city: "São Paulo",
    state: "SP",
    zip_code: "04538-000",
    discount_percentage: 20.0,
    active: true,
    notes: "Neurologista com foco em doenças neurodegenerativas"
  }
]

# Criar profissionais médicos
medical_professionals.each do |prof_data|
  professional = MedicalProfessional.find_or_create_by(crm: prof_data[:crm]) do |prof|
    prof.assign_attributes(prof_data)
  end
  puts "✓ #{professional.name} - #{professional.specialty} - CRM: #{professional.crm} - Desconto: #{professional.discount_percentage}%"
end

puts "\nProfissionais médicos criados com sucesso!"
puts "Total: #{MedicalProfessional.count} profissionais cadastrados"
puts "Ativos: #{MedicalProfessional.active.count}"
puts "Inativos: #{MedicalProfessional.where(active: false).count}"
