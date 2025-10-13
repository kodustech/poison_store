# Regras de Negócio - Sistema de Parcelamento de Medicamentos

## Visão Geral
Este documento descreve as regras de negócio implementadas no sistema de parcelamento da Poison Store, que define automaticamente as opções de pagamento disponíveis para a compra de medicamentos com base no valor total da venda.

## Funcionalidades Principais

### 1. Sistema de Parcelamento Automático
- **Ativação**: O parcelamento é calculado automaticamente com base no valor final da venda
- **Validação**: Sistema valida o número máximo de parcelas permitido para cada faixa de valor
- **Flexibilidade**: Cliente pode escolher pagar em menos parcelas do que o máximo permitido
- **Transparência**: Todas as opções de parcelamento são apresentadas claramente ao cliente

### 2. Faixas de Parcelamento

#### Tabela de Parcelamento:
| Valor da Compra | Parcelas Permitidas | Descrição |
|----------------|--------------------|-----------| 
| Até R$ 100,00 | 1x | À vista |
| R$ 101,00 a R$ 300,00 | Até 2x | Duas parcelas |
| R$ 301,00 a R$ 450,00 | Até 3x | Três parcelas |
| R$ 451,00 a R$ 500,00 | Até 4x | Quatro parcelas |
| R$ 501,00 a R$ 600,00 | Até 5x | Cinco parcelas |
| R$ 601,00 a R$ 1.000,00 | Até 6x | Seis parcelas |
| Acima de R$ 1.000,00 | Até 8x | Oito parcelas |

### 3. Cálculo das Parcelas
- **Valor da Parcela**: Valor Total ÷ Número de Parcelas
- **Arredondamento**: 2 casas decimais
- **Ajuste**: Diferença de centavos é adicionada à primeira parcela
- **Sem Juros**: Todas as parcelas são sem juros

## Fluxo de Pagamento

### Passo a Passo:
1. **Seleção do Medicamento**: Cliente escolhe o medicamento e quantidade
2. **Aplicação de Descontos**: Sistema aplica descontos (se aplicável)
3. **Cálculo do Valor Final**: Sistema calcula o valor total da compra
4. **Determinação de Parcelas**: Sistema determina automaticamente as opções de parcelamento
5. **Apresentação de Opções**: Cliente visualiza todas as formas de pagamento disponíveis
6. **Seleção do Método**: Cliente escolhe a forma de pagamento desejada
7. **Confirmação**: Sistema registra a venda com o método de pagamento selecionado
8. **Finalização**: Emissão de comprovante com detalhes do pagamento

### Campos Adicionais na Venda:
- `payment_method`: Método de pagamento (à vista, cartão, etc)
- `installments`: Número de parcelas escolhidas
- `installment_value`: Valor de cada parcela
- `max_installments`: Número máximo de parcelas permitido
- `total_amount`: Valor total da compra
- `payment_date`: Data do pagamento

## Interface do Usuário

### Tela de Venda:
- **Valor Total**: Exibição destacada do valor total da compra
- **Opções de Parcelamento**: Lista com todas as parcelas disponíveis
- **Calculadora de Parcelas**: Mostra o valor de cada parcela em tempo real
- **Método de Pagamento**: Seleção entre dinheiro, débito, crédito, PIX
- **Resumo**: Apresentação clara da opção selecionada

### Listagem de Vendas:
- **Coluna de Pagamento**: Exibe método e número de parcelas
- **Valor das Parcelas**: Mostra valor unitário de cada parcela
- **Status**: Indica se o pagamento foi à vista ou parcelado
- **Total Pago**: Valor total da transação

## Relatórios e Consultas

### Filtros Disponíveis:
- Por método de pagamento
- Por número de parcelas
- Por faixa de valor
- Por período de venda
- Por status de pagamento

### Relatórios Gerenciais:
- Vendas por forma de pagamento
- Média de parcelas por período
- Ticket médio por forma de pagamento
- Análise de parcelamento vs à vista

## Regras de Negócio Específicas

### 1. Aplicação do Parcelamento
- ✅ **Permitido**: Parcelamento dentro da faixa de valor correspondente
- ✅ **Permitido**: Cliente escolher menos parcelas que o máximo
- ❌ **Não Permitido**: Ultrapassar o número máximo de parcelas para a faixa
- ❌ **Não Permitido**: Parcelas com valor inferior a R$ 10,00

### 2. Validações de Valor
- **Valor Mínimo por Parcela**: R$ 10,00
- **Arredondamento**: Sempre 2 casas decimais
- **Primeira Parcela**: Pode ter centavos a mais para ajuste
- **Valores Negativos**: Não são permitidos

### 3. Cálculo de Parcelas
- **Fórmula Base**: Valor Total ÷ Número de Parcelas
- **Arredondamento**: Math.round com 2 decimais
- **Ajuste de Centavos**: (Valor Total - (Parcela × Quantidade)) + Parcela
- **Validação Final**: Soma das parcelas = Valor Total

### 4. Auditoria
- Todas as vendas registram:
  - Método de pagamento escolhido
  - Número de parcelas
  - Valor de cada parcela
  - Valor total
  - Data e hora da transação
  - Parcelas máximas disponíveis no momento

## Exemplos Práticos

### Exemplo 1: Compra de R$ 95,00
- **Valor**: R$ 95,00
- **Parcelas Permitidas**: 1x
- **Opções**: À vista R$ 95,00
- **Observação**: Abaixo do limite para parcelamento

### Exemplo 2: Compra de R$ 250,00
- **Valor**: R$ 250,00
- **Parcelas Permitidas**: 1x ou 2x
- **Opções**: 
  - 1x de R$ 250,00
  - 2x de R$ 125,00

### Exemplo 3: Compra de R$ 380,00
- **Valor**: R$ 380,00
- **Parcelas Permitidas**: 1x, 2x ou 3x
- **Opções**:
  - 1x de R$ 380,00
  - 2x de R$ 190,00
  - 3x de R$ 126,67

### Exemplo 4: Compra de R$ 475,00
- **Valor**: R$ 475,00
- **Parcelas Permitidas**: 1x, 2x, 3x ou 4x
- **Opções**:
  - 1x de R$ 475,00
  - 2x de R$ 237,50
  - 3x de R$ 158,33
  - 4x de R$ 118,75

### Exemplo 5: Compra de R$ 550,00
- **Valor**: R$ 550,00
- **Parcelas Permitidas**: 1x, 2x, 3x, 4x ou 5x
- **Opções**:
  - 1x de R$ 550,00
  - 2x de R$ 275,00
  - 3x de R$ 183,33
  - 4x de R$ 137,50
  - 5x de R$ 110,00

### Exemplo 6: Compra de R$ 800,00
- **Valor**: R$ 800,00
- **Parcelas Permitidas**: 1x até 6x
- **Opções**:
  - 1x de R$ 800,00
  - 2x de R$ 400,00
  - 3x de R$ 266,67
  - 4x de R$ 200,00
  - 5x de R$ 160,00
  - 6x de R$ 133,33

### Exemplo 7: Compra de R$ 1.200,00
- **Valor**: R$ 1.200,00
- **Parcelas Permitidas**: 1x até 8x
- **Opções**:
  - 1x de R$ 1.200,00
  - 2x de R$ 600,00
  - 3x de R$ 400,00
  - 4x de R$ 300,00
  - 5x de R$ 240,00
  - 6x de R$ 200,00
  - 7x de R$ 171,43
  - 8x de R$ 150,00

## Manutenção e Configuração

### Gestão de Regras:
- **Atualização de Faixas**: Alteração dos limites de valor
- **Modificação de Parcelas**: Ajuste do número máximo por faixa
- **Histórico**: Rastreamento de mudanças nas regras
- **Versioning**: Controle de versão das regras de parcelamento

### Configuração do Sistema:
- **Limites Configuráveis**: Valores das faixas podem ser ajustados
- **Parcela Mínima**: Valor mínimo configurável por parcela
- **Métodos de Pagamento**: Cartão, Dinheiro, PIX, Débito
- **Logs**: Registro de todas as operações de pagamento

## Considerações Técnicas

### Performance:
- Cálculo de parcelas em tempo real
- Cache de configurações de parcelamento
- Validação otimizada de faixas de valor

### Segurança:
- Validação de valores no backend
- Sanitização de dados de entrada
- Proteção contra manipulação de valores
- Auditoria completa de transações

### Escalabilidade:
- Modelo flexível para novas formas de pagamento
- API REST para integrações futuras
- Estrutura preparada para múltiplas filiais
- Suporte para diferentes moedas (futuro)

## Integração com Outros Módulos

### Sistema de Descontos:
- O parcelamento é calculado sobre o **valor final** após descontos
- Descontos médicos são aplicados **antes** do cálculo de parcelas
- Descontos especiais (idosos, PCD) também são aplicados antes
- Valor final com todos os descontos = Base para parcelamento

### Fluxo Integrado:
1. Cálculo do preço original (quantidade × valor unitário)
2. Aplicação de descontos (médico, idoso, PCD)
3. Cálculo do valor final
4. Determinação das opções de parcelamento
5. Seleção pelo cliente
6. Finalização da venda

## Regras de Conformidade

### Legal:
- Sem cobrança de juros nas parcelas
- Informação clara ao consumidor (CDC)
- Registro de todas as condições acordadas
- Comprovante com detalhes completos

### Comercial:
- Competitividade com outras farmácias
- Flexibilidade para o cliente
- Gestão de fluxo de caixa
- Análise de preferências de pagamento

## Casos Especiais

### Valores com Desconto:
- **Exemplo**: Compra de R$ 600,00 com 15% de desconto médico
- **Valor Original**: R$ 600,00
- **Desconto**: R$ 90,00
- **Valor Final**: R$ 510,00
- **Parcelas**: Até 5x (baseado em R$ 510,00)
- **Opções**: 1x até 5x de R$ 102,00

### Múltiplos Itens:
- Soma-se o valor total de todos os itens
- Descontos são aplicados item a item
- Parcelamento é calculado sobre o total final
- Cliente vê o resumo completo antes de confirmar

## Conclusão

O sistema de parcelamento implementado garante:
- **Flexibilidade**: Opções adequadas para diferentes faixas de valor
- **Transparência**: Cliente conhece todas as opções disponíveis
- **Controle**: Gestão eficiente do fluxo de caixa
- **Auditoria**: Rastreamento completo de todas as transações
- **Conformidade**: Aderência às normas de defesa do consumidor
- **Competitividade**: Condições atrativas para os clientes

Este sistema atende às necessidades comerciais da farmácia, proporcionando uma experiência transparente para os clientes e controle total para a gestão, facilitando o acesso aos medicamentos através de condições de pagamento flexíveis e sem juros.

