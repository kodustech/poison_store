# Poison Store - Sistema de Gestão de Farmácia

Projeto criado para a validação do AST

## Funcionalidades Implementadas

### 1. Busca de Médicos por CRM
- **Rota**: `GET /reports/search_doctors`
- **Funcionalidade**: Permite buscar médicos pelo número de CRM (busca parcial)
- **Recursos**:
  - Busca por CRM exato ou parcial
  - Estatísticas de prescrições por médico
  - Contagem de medicamentos únicos prescritos
  - Histórico de atividade (primeira e última prescrição)
  - Visualização detalhada em modal
  - Exportação em JSON

### 2. Relatórios de Top Medicamentos
- **Rota**: `GET /reports/top_medications`
- **Funcionalidade**: Ranking dos medicamentos mais solicitados por período
- **Recursos**:
  - Filtros por data de início e fim
  - Contagem de vendas por medicamento
  - Exportação em JSON

### 3. Sistema de Prescrições
- **Rota**: `POST /medication_requests`
- **Funcionalidade**: Cadastro de solicitações de medicamentos
- **Campos**: Nome, CPF, endereço, telefone, email, renda mensal, nome do medicamento, foto da prescrição, CRM do médico, quantidade

## Estrutura do Projeto

### Controllers
- `ReportsController`: Gerencia relatórios e consultas
- `MedicationRequestsController`: Gerencia solicitações de medicamentos

### Models
- `MedicationRequest`: Modelo principal para prescrições
- `Customer`: Modelo de clientes
- `Supplier`: Modelo de fornecedores
- `Potion`: Modelo de medicamentos

### Views
- `reports/index.html.erb`: Página principal dos relatórios
- `reports/search_doctors.html.erb`: Interface de busca de médicos
- `reports/top_medications.html.erb`: Relatório de top medicamentos

## Como Usar

### Busca de Médicos por CRM
1. Acesse `/reports` para ver o menu principal
2. Clique em "Buscar Médicos"
3. Digite o CRM (ou parte dele) no campo de busca
4. Visualize os resultados com estatísticas detalhadas
5. Use os modais para ver informações completas de cada médico

### Relatórios
1. Acesse `/reports` para ver todas as opções disponíveis
2. Escolha entre busca de médicos ou top medicamentos
3. Configure filtros conforme necessário
4. Exporte dados em JSON se necessário

## Tecnologias Utilizadas
- Ruby on Rails
- MongoDB com Mongoid
- Bootstrap para interface
- RSpec para testes

## Código Replicado
- app > services: os files *customer_report_service.rb* e *supplier_report_service* possuem funções idênticas para gerar pdf -> **generate_pdf**

## Código não reaproveitado
- O arquivo *address_utils.rb* possui uma função de buscar endereço através do CEP informado. Essa função está sendo chamada no arquivo *customer.rb* da models
- Já no arquivo *supplier.rb* da models, existe a mesma função da utils para buscar endereço por CEP
