# Table Data Gateway

**Classificação**: Padrão Arquitetural de Fonte de Dados

---

## Intenção e Objetivo

Um objeto que atua como Gateway para uma tabela de banco de dados. Uma instância trata todas as linhas da tabela. Os métodos encapsulam consultas e operações de atualização, retornando dados em estruturas genéricas como RecordSet.

## Também Conhecido Como

- Table Gateway
- Data Access Object (parcialmente)
- Table DAO

## Motivação

Quando o código da aplicação acessa o banco de dados diretamente, o SQL fica espalhado por toda a aplicação, dificultando a manutenção e a modificação do esquema do banco. O Table Data Gateway resolve isso encapsulando todo o acesso a dados de uma tabela em uma única classe.

Cada tabela tem seu Gateway que fornece métodos para operações comuns: inserir, atualizar, deletar, buscar. Por exemplo, PersonGateway teria métodos como insert(name, age), update(id, name, age), delete(id), findById(id), findAll(). Todo o SQL da tabela Person fica isolado nessa classe.

O Gateway retorna dados em estruturas genéricas como RecordSet, DataTable ou dicionários, não em objetos de domínio específicos. Isso mantém o Gateway focado apenas no acesso a dados, sem conhecimento de lógica de negócio. O client pode ser Transaction Script, Table Module ou Data Mapper.

## Aplicabilidade

Use Table Data Gateway quando:

- O SQL precisa ser separado da lógica de domínio e de apresentação
- Múltiplas operações na mesma tabela precisam ser reutilizadas
- O acesso a dados deve ser centralizado para facilitar a manutenção
- O processamento opera sobre múltiplas linhas simultaneamente
- A plataforma tem bom suporte para estruturas de dados genéricas (RecordSet)
- Não há necessidade de mapear para objetos de domínio ricos

## Estrutura

```
Client (Transaction Script, Table Module ou UI)
└── Usa: Table Data Gateway

Table Data Gateway (um por tabela)
├── PersonGateway
│   ├── insert(name, email, age): id
│   ├── update(id, name, email, age)
│   ├── delete(id)
│   ├── findById(id): RecordSet
│   ├── findAll(): RecordSet
│   └── findByEmail(email): RecordSet
│
├── OrderGateway
│   ├── insert(customerId, date, total): id
│   ├── update(id, status, total)
│   ├── delete(id)
│   ├── findById(id): RecordSet
│   └── findByCustomer(customerId): RecordSet
│
└── ProductGateway
    ├── insert(name, price, stock): id
    ├── update(id, price, stock)
    ├── findById(id): RecordSet
    └── findAvailable(): RecordSet

Banco de Dados
└── Tabelas (Person, Order, Product)
```

## Participantes

- [**Table Data Gateway**](001_table-data-gateway.md): Classe que encapsula o acesso a uma tabela específica
- **RecordSet/DataTable**: Estrutura de dados genérica contendo as linhas retornadas
- **Conexão com o Banco de Dados**: Conexão utilizada pelo Gateway
- **Instruções SQL**: Comandos SQL encapsulados nos métodos do Gateway
- **Client**: Transaction Script, Table Module ou UI que utiliza o Gateway

## Colaborações

- O Client invoca um método no Table Data Gateway (ex.: personGateway.findById(5))
- O Gateway monta a instrução SQL adequada para a operação
- O Gateway executa o SQL usando a conexão com o banco de dados
- Para consultas, o Gateway converte os resultados em RecordSet ou estrutura similar
- O Gateway retorna o RecordSet ao Client
- O Client processa os dados usando a estrutura genérica retornada
- Para atualizações, o Gateway executa INSERT/UPDATE/DELETE e retorna o status

## Consequências

### Vantagens

- **SQL centralizado**: Todo o SQL da tabela em um só lugar
- **Manutenibilidade**: Mudanças no esquema afetam apenas o Gateway
- **Reusabilidade**: Consultas comuns disponíveis para todos os clients
- **Testabilidade**: Fácil criar mocks do Gateway para testes
- **Separação de responsabilidades**: Acesso a dados separado da lógica
- **Simplicidade**: Mais simples do que um Data Mapper completo

### Desvantagens

- **Acoplamento à estrutura de dados**: Clients acoplados ao RecordSet específico
- **Granularidade**: Um Gateway por tabela pode ser excessivo para esquemas grandes
- **Sem objetos de domínio**: Não mapeia para objetos ricos; retorna dados genéricos
- **Consultas complexas**: Difícil tratar joins complexos entre múltiplas tabelas
- **Identidade**: Não gerencia identidade de objetos
- **Relacionamentos**: Difícil navegar relacionamentos entre entidades

## Implementação

### Considerações

1. **Um Gateway por tabela**: Crie uma classe separada para cada tabela do banco de dados
2. **Métodos finder**: Métodos que retornam RecordSets (findById, findByXXX)
3. **Métodos de comando**: Métodos para INSERT, UPDATE, DELETE
4. **Gerenciamento de conexão**: Decida se o Gateway gerencia a conexão ou a recebe
5. **Retorno de dados**: Use RecordSet, DataTable, array de dicionários ou similar
6. **Transações**: Gerencie transações fora do Gateway (na Service Layer)

### Técnicas

- **Métodos Estáticos**: Use métodos estáticos se o Gateway não mantiver estado
- **Instância por Tabela**: Crie uma instância do Gateway para usar
- **RecordSet Genérico**: Retorne as estruturas de dados genéricas da plataforma
- **Métodos Finder**: Métodos find* para diversas consultas
- **Métodos de Comando**: Métodos insert/update/delete para modificações
- **Injeção de Conexão**: Injete a conexão em vez de criá-la internamente

## Usos Conhecidos

- **Aplicações ADO.NET**: TableAdapters em DataSets
- **Padrão DAO Java**: Data Access Objects em aplicações Java
- **Aplicações Empresariais**: Camada de acesso a dados em aplicações corporativas
- **Integração com Sistemas Legados**: Gateway para sistemas legados baseados em tabelas
- **Sistemas de Relatórios**: Acesso a dados para geração de relatórios
- **Aplicações CRUD**: Aplicações simples de Criar-Ler-Atualizar-Deletar

## Padrões Relacionados

- [**Row Data Gateway**](002_row-data-gateway.md): Alternativa com Gateway por linha
- [**Active Record**](003_active-record.md): Combina Gateway com objeto de domínio
- [**Data Mapper**](004_data-mapper.md): Mapeia para objetos de domínio ricos
- [**Table Module**](../domain-logic/003_table-module.md): Usa o Table Data Gateway para obter dados
- [**Transaction Script**](../domain-logic/001_transaction-script.md): Pode usar Gateway para acesso
- [**Service Layer**](../domain-logic/004_service-layer.md): Service Layer pode usar Gateways
- [**GoF Gateway**](../base/001_gateway.md): Padrão base Gateway
- [**Record Set**](../base/011_record-set.md): Estrutura de dados retornada

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): Gateway responsável pelo acesso
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): client depende da interface
- [021 - Prohibition of Duplication](../../clean-code/proibicao-duplicacao-logica.md): SQL não duplicado
- [007 - Lines per Class Limit](../../object-calisthenics/007_limite-maximo-linhas-classe.md): Gateway conciso

---

**Criado em**: 2025-01-11
**Versão**: 1.0
