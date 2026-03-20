# Table Module

**Classificação**: Padrão de Lógica de Domínio

---

## Intenção e Objetivo

Organizar a lógica de domínio com uma classe por tabela do banco de dados. Uma única instância da classe contém o comportamento compartilhado que opera sobre um RecordSet representando múltiplas linhas da tabela.

## Também Conhecido Como

- Table Gateway
- Table Object

## Motivação

O Table Module oferece um meio-termo entre a simplicidade do Transaction Script e a riqueza do Domain Model. Em vez de procedimentos independentes ou objetos por linha, você tem uma classe que encapsula o comportamento comum para todas as linhas de uma tabela.

Considere um sistema de contratos onde é preciso calcular a receita reconhecida. Com o Table Module, uma classe ContractsModule teria um método calculateRecognitions(contractsRecordSet) que processa múltiplos contratos simultaneamente. O RecordSet transita entre as camadas carregando os dados, enquanto o módulo fornece toda a lógica de negócio.

Essa abordagem funciona particularmente bem em plataformas com suporte robusto a estruturas de dados tabulares, como ADO.NET DataSets ou JDBC Result Sets. O comportamento compartilhado é centralizado, mas você ainda trabalha com estruturas de dados familiares.

## Aplicabilidade

Use Table Module quando:

- A lógica de domínio tiver complexidade moderada
- A plataforma oferecer excelente suporte a estruturas RecordSet
- A equipe estiver confortável com programação orientada a dados
- Houver comportamento comum compartilhado entre linhas da mesma tabela
- O processamento em lote sobre múltiplas linhas for comum
- A sobrecarga de um Domain Model completo não for justificada

## Estrutura

```
Cliente (Camada de Apresentação)
└── Usa: TableModule + RecordSet

TableModule (uma classe por tabela)
├── ProductsModule
│   ├── calculateDiscount(RecordSet)
│   ├── applyPriceAdjustment(RecordSet)
│   └── findAvailableProducts(): RecordSet
│
├── OrdersModule
│   ├── calculateTotal(RecordSet)
│   ├── applyShippingRules(RecordSet)
│   └── findOrdersByCustomer(customerId): RecordSet
│
└── CustomersModule
    ├── calculateLoyaltyPoints(RecordSet)
    └── findActiveCustomers(): RecordSet

RecordSet
└── Estrutura de dados contendo múltiplas linhas e colunas
```

## Participantes

- [**Table Module**](003_table-module.md): Classe que contém a lógica de negócio para todas as linhas de uma tabela específica
- **RecordSet**: Estrutura de dados que representa múltiplas linhas; pode ser DataSet, DataTable ou similar
- [**Table Data Gateway**](../data-source/001_table-data-gateway.md): Fornece dados ao Table Module (frequentemente retorna RecordSets)
- **Cliente**: Interface de usuário ou camada de serviço que invoca os Table Modules

## Colaborações

- O cliente obtém o RecordSet do Table Data Gateway ou diretamente do banco de dados
- O cliente passa o RecordSet ao Table Module para processar a lógica de negócio
- O Table Module executa operações sobre todas as linhas do RecordSet
- O Table Module pode modificar o RecordSet in-place ou retornar um novo RecordSet
- O RecordSet modificado retorna ao cliente ou é passado para persistência

## Consequências

### Vantagens

- **Simplicidade moderada**: Mais estruturado que Transaction Script; menos complexo que Domain Model
- **RecordSet nativo**: Aproveita o suporte nativo da plataforma a estruturas tabulares
- **Comportamento centralizado**: Toda a lógica da tabela em um único lugar
- **Desempenho em lote**: Processa múltiplas linhas com eficiência
- **Familiar aos desenvolvedores**: Estrutura de dados conhecida; baixa curva de aprendizado
- **Compartilhamento natural**: Fácil compartilhar comportamento entre linhas

### Desvantagens

- **Acoplamento ao RecordSet**: Forte dependência de estruturas de dados específicas da plataforma
- **Complexidade limitada**: Não escala bem para domínios muito complexos
- **OO limitado**: Não aproveita polimorfismo, herança e outros recursos avançados
- **Mapeamento objeto-relacional**: Ainda há impedância, apenas diferente
- **Identidade fraca**: Difícil rastrear a identidade de objetos individuais
- **Dificuldade com relacionamentos**: Relacionamentos complexos são difíceis de gerenciar

## Implementação

### Considerações

1. **Uma classe por tabela**: Crie um Table Module separado para cada tabela do banco de dados
2. **Instância vs estático**: Decida se os métodos devem ser estáticos ou de instância
3. **RecordSet como parâmetro**: Os métodos recebem RecordSets e operam sobre eles
4. **Retornando RecordSets**: As consultas retornam RecordSets para processamento subsequente
5. **Validação**: Encapsule as validações de negócio nos módulos
6. **Transações**: Gerencie as transações externamente ao módulo

### Técnicas

- **Métodos Estáticos**: Use métodos estáticos se o módulo não tiver estado
- **Métodos de Instância**: Use instância se o módulo precisar manter estado (conexões, configuração)
- **Manipulação de RecordSet**: Operações que modificam o RecordSet in-place
- **Métodos de Consulta**: Retornam RecordSets filtrados ou transformados
- **Métodos de Cálculo**: Calculam valores com base nos dados do RecordSet
- **Métodos de Validação**: Validam regras de negócio sobre múltiplas linhas

## Usos Conhecidos

- **Aplicações ADO.NET**: Aplicações .NET usando DataSets e DataTables
- **Classic ASP/VB6**: Aplicações Visual Basic clássicas com ADO RecordSets
- **Java com JDBC**: Aplicações Java processando ResultSets
- **Geração de Relatórios**: Sistemas de relatórios operando sobre dados tabulares
- **Ferramentas de Migração de Dados**: Ferramentas ETL processando dados em lote
- **Interfaces Administrativas**: Interfaces de administração com operações em lote

## Padrões Relacionados

- [**Transaction Script**](001_transaction-script.md): O Table Module adiciona organização por tabela
- [**Domain Model**](002_domain-model.md): Mais rico e OO; Table Module é mais simples
- [**Service Layer**](004_service-layer.md): Table Modules podem formar uma Service Layer
- [**Table Data Gateway**](../data-source/001_table-data-gateway.md): Fornece RecordSets ao Table Module
- [**Row Data Gateway**](../data-source/002_row-data-gateway.md): Alternativa orientada a linha única
- [**Active Record**](../data-source/003_active-record.md): Combina dados e comportamento por instância
- [**Record Set**](../base/011_record-set.md): Estrutura de dados usada pelo Table Module

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): módulo por tabela
- [004 - First-Class Collections](../../object-calisthenics/004_colecoes-primeira-classe.md): opera sobre coleções de linhas
- [007 - Maximum Lines per Class Limit](../../object-calisthenics/007_limite-maximo-linhas-classe.md): módulos devem ser concisos
- [022 - Prioritization of Simplicity](../../clean-code/priorizacao-simplicidade-clareza.md): solução simples para complexidade moderada

---

**Criado em**: 2025-01-11
**Versão**: 1.0
