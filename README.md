Projeto criado para a validação do AST

## Código Replicado
- app > services: os files *customer_report_service.rb* e *supplier_report_service* possuem funções idênticas para gerar pdf -> **generate_pdf**

## Código não reaproveitado
- O arquivo *address_utils.rb* possui uma função de buscar endereço através do CEP informado. Essa função está sendo chamada no arquivo *customer.rb* da models
- Já no arquivo *supplier.rb* da models, existe a mesma função da utils para buscar endereço por CEP
