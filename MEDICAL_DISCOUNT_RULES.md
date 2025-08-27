# Regras de Negócio - Sistema de Desconto Médico

## Visão Geral
Este documento descreve as regras de negócio implementadas no sistema de desconto médico da Poison Store, que permite que profissionais médicos cadastrados gerem descontos automáticos em vendas de medicamentos quando o paciente apresentar receita com seu CRM.

## Funcionalidades Principais

### 1. Cadastro de Profissionais Médicos
- **Campos obrigatórios**: Nome, CRM, Especialidade, Percentual de Desconto
- **Campos opcionais**: Telefone, E-mail, Endereço completo, Observações
- **Validações**:
  - CRM deve ser único no sistema
  - CRM deve conter apenas números (2 a 10 dígitos)
  - Percentual de desconto deve estar entre 0% e 50%
  - E-mail deve ter formato válido (se informado)

### 2. Sistema de Desconto Automático
- **Ativação**: Desconto é aplicado automaticamente quando:
  - A venda é marcada como "com receita médica"
  - O CRM do médico é informado
  - O CRM existe no sistema e está ativo
  - O profissional médico está cadastrado e ativo

- **Cálculo do Desconto**:
  - Desconto = (Preço Original × Percentual de Desconto) ÷ 100
  - Preço Final = Preço Original - Desconto
  - Todos os valores são arredondados para 2 casas decimais

### 3. Validações de Segurança
- **CRM Inativo**: Profissionais inativos não podem gerar descontos
- **Receita Obrigatória**: Desconto só é aplicado com receita médica
- **CRM Válido**: Apenas CRMs cadastrados no sistema são aceitos
- **Formato CRM**: Validação de formato numérico (2-10 dígitos)

## Fluxo de Venda com Desconto

### Passo a Passo:
1. **Seleção de Medicamento**: Cliente escolhe o medicamento
2. **Informações do Cliente**: Dados pessoais são preenchidos
3. **Receita Médica**: Marcar checkbox "Vendido com Receita Médica"
4. **Dados do Médico**: Preencher nome e CRM do médico
5. **Validação CRM**: Sistema busca automaticamente o CRM
6. **Aplicação do Desconto**: Desconto é calculado e aplicado
7. **Confirmação**: Sistema mostra informações do desconto aplicado
8. **Finalização**: Venda é registrada com preço final descontado

### Campos Adicionais na Venda:
- `discount_percentage`: Percentual de desconto aplicado
- `discount_applied`: Valor do desconto em reais
- `original_price`: Preço original (quantidade × preço unitário)
- `final_price`: Preço final após desconto
- `total_price`: Preço total da venda (igual ao final_price)

## Interface do Usuário

### Tela de Venda:
- **Campo CRM**: Com botão de busca integrado
- **Resultado da Busca**: Mostra informações do médico encontrado
- **Informações de Desconto**: Exibe detalhes do desconto aplicado
- **Cálculo Automático**: Preço é recalculado automaticamente

### Listagem de Vendas:
- **Coluna Desconto**: Mostra percentual e valor do desconto
- **Preço Total**: Exibe preço original riscado e preço final
- **Informações do Médico**: CRM e nome do médico (se aplicável)

## Relatórios e Consultas

### Busca por CRM:
- Endpoint: `GET /medical_professionals/search_by_crm?crm=12345`
- Retorna informações do profissional se encontrado
- Usado para validação em tempo real durante a venda

### Filtros Disponíveis:
- Por especialidade médica
- Por cidade
- Por status (ativo/inativo)
- Busca por nome, CRM ou especialidade

## Regras de Negócio Específicas

### 1. Aplicação de Desconto
- ✅ **Permitido**: Venda com receita + CRM válido + Profissional ativo
- ❌ **Não Permitido**: Venda sem receita
- ❌ **Não Permitido**: CRM não cadastrado
- ❌ **Não Permitido**: Profissional inativo

### 2. Validações de CRM
- Formato: Apenas números
- Tamanho: 2 a 10 dígitos
- Unicidade: CRM deve ser único no sistema
- Status: Profissional deve estar ativo

### 3. Cálculo de Preços
- **Preço Original**: Quantidade × Preço Unitário
- **Desconto**: (Preço Original × Percentual) ÷ 100
- **Preço Final**: Preço Original - Desconto
- **Arredondamento**: 2 casas decimais

### 4. Auditoria
- Todas as vendas com desconto registram:
  - CRM do médico
  - Percentual de desconto aplicado
  - Valor do desconto
  - Preço original e final
  - Data e hora da aplicação

## Exemplos Práticos

### Exemplo 1: Desconto de 15%
- **Medicamento**: R$ 50,00
- **Quantidade**: 2 unidades
- **Preço Original**: R$ 100,00
- **Desconto**: 15% = R$ 15,00
- **Preço Final**: R$ 85,00

### Exemplo 2: Desconto de 20%
- **Medicamento**: R$ 75,00
- **Quantidade**: 1 unidade
- **Preço Original**: R$ 75,00
- **Desconto**: 20% = R$ 15,00
- **Preço Final**: R$ 60,00

## Manutenção e Configuração

### Gestão de Profissionais:
- **Ativação/Desativação**: Controle de status do profissional
- **Edição de Descontos**: Alteração de percentuais
- **Histórico**: Rastreamento de mudanças
- **Backup**: Dados são preservados mesmo quando inativo

### Configurações do Sistema:
- **Limite de Desconto**: Máximo de 50%
- **Validação de Formato**: Regex para CRM
- **Cache**: Busca otimizada de profissionais
- **Logs**: Registro de todas as operações

## Considerações Técnicas

### Performance:
- Índices no banco para CRM e status
- Cache de profissionais ativos
- Validação em tempo real via AJAX

### Segurança:
- Validação de entrada para CRM
- Sanitização de dados
- Controle de acesso por sessão

### Escalabilidade:
- Modelo flexível para novos campos
- API REST para integrações futuras
- Estrutura preparada para múltiplas farmácias

## Conclusão

O sistema de desconto médico implementado garante:
- **Conformidade**: Apenas profissionais cadastrados geram descontos
- **Transparência**: Cliente vê claramente o desconto aplicado
- **Controle**: Gestão completa de profissionais e descontos
- **Auditoria**: Rastreamento completo de todas as operações
- **Flexibilidade**: Configuração individual de percentuais por médico

Este sistema atende às necessidades regulatórias e comerciais da farmácia, proporcionando uma experiência transparente para clientes e controle total para a gestão.
