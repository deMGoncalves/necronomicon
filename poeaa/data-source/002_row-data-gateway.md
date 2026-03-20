# Row Data Gateway

**Classificação**: Padrão Arquitetural de Fonte de Dados

---

## Intenção e Objetivo

Um objeto que atua como Gateway para uma única linha de uma tabela de banco de dados. Uma instância da classe representa uma linha; o objeto sabe como carregar, atualizar e deletar a si mesmo no banco de dados.

## Também Conhecido Como

- Row Gateway
- Record Gateway
- Table Row

## Motivação

O Row Data Gateway fornece uma camada objeto-relacional simples onde cada objeto corresponde exatamente a uma linha do banco de dados. Cada campo da tabela tem uma propriedade correspondente no objeto. Os métodos encapsulam operações SQL para carregar, salvar e deletar a linha.

Ao contrário do Table Data Gateway (que trata múltiplas linhas), cada instância do Row Data Gateway representa uma única linha. Criar um novo registro significa criar uma nova instância e chamar o método insert(). Atualizar significa modificar as propriedades e chamar update(). Deletar significa chamar delete() no objeto.

Por exemplo, PersonGateway (objeto) representa uma linha na tabela Person. Possui as propriedades id, name, email, age que refletem as colunas. Os métodos insert(), update(), delete() encapsulam o SQL. O finder estático findById() retorna a instância carregada. É mais orientado a objetos que o Table Data Gateway, mas ainda não contém lógica de negócio.

## Aplicabilidade

Use Row Data Gateway quando:

- A estrutura do objeto corresponde bem à estrutura da tabela
- A lógica de domínio é simples e separada do acesso a dados
- Deseja-se separação clara entre dados (Gateway) e comportamento (Transaction Script)
- Não há necessidade de comportamento rico nos objetos de dados
- Transaction Scripts ou Table Modules são o padrão de domínio escolhido
- A incompatibilidade objeto-relacional é mínima

## Estrutura

```
Client (Transaction Script ou Lógica de Negócio)
└── Usa: instâncias de Row Data Gateway

Row Data Gateway (uma classe por tabela)
├── PersonGateway
│   ├── Propriedades: id, name, email, age
│   ├── insert(): salva nova linha
│   ├── update(): atualiza linha existente
│   ├── delete(): remove linha
│   └── findById(id): PersonGateway (estático)
│
├── OrderGateway
│   ├── Propriedades: id, customerId, date, total, status
│   ├── insert()
│   ├── update()
│   ├── delete()
│   ├── findById(id): OrderGateway (estático)
│   └── findByCustomer(customerId): OrderGateway[] (estático)
│
└── ProductGateway
    ├── Propriedades: id, name, price, stock
    ├── insert()
    ├── update()
    ├── delete()
    └── findById(id): ProductGateway (estático)

Banco de Dados
└── Tabelas espelhadas pelas classes Gateway
```

## Participantes

- [**Row Data Gateway**](002_row-data-gateway.md): Classe que representa a estrutura de uma linha da tabela
- **Propriedades/Campos**: Campos correspondentes às colunas da tabela
- **Métodos de Instância**: insert(), update(), delete() operando na instância
- **Métodos Finder Estáticos**: Métodos estáticos que retornam instâncias (findById, etc)
- **Conexão com o Banco de Dados**: Conexão usada para executar o SQL
- **Client**: Transaction Script ou código de negócio usando o Gateway

## Colaborações

- O Client cria uma nova instância de Row Data Gateway ou a obtém via finder
- Para criar um novo registro: o Client cria a instância, define as propriedades e chama insert()
- Gateway.insert() executa o INSERT SQL e armazena o ID gerado na instância
- Para carregar: o Client chama PersonGateway.findById(5) (método estático)
- O finder executa o SELECT, cria a instância, popula as propriedades e retorna o objeto
- Para atualizar: o Client modifica as propriedades do objeto e chama update()
- Gateway.update() executa o UPDATE SQL usando os valores das propriedades
- Para deletar: o Client chama delete() na instância
- Gateway.delete() executa o DELETE SQL usando o ID da instância

## Consequências

### Vantagens

- **Simplicidade**: Mapeamento direto e simples entre linha e objeto
- **Separação de dados**: Dados separados da lógica de negócio
- **Facilidade de uso**: Interface orientada a objetos intuitiva
- **Encapsulamento SQL**: SQL concentrado no Gateway
- **Testabilidade**: Fácil criar mocks do Gateway
- **Identidade**: Cada objeto representa uma linha específica

### Desvantagens

- **Apenas dados**: Os objetos são anêmicos; sem comportamento de negócio
- **Acoplamento ao esquema**: Mudanças no esquema afetam o Gateway
- **Relacionamentos**: Difícil tratar relacionamentos complexos
- **Desempenho**: Uma consulta por objeto pode ser ineficiente
- **Incompatibilidade**: Não resolve problemas OO mais complexos
- **Proliferação de classes**: Uma classe por tabela pode ser excessivo

## Implementação

### Considerações

1. **Propriedades por coluna**: Cada coluna da tabela se torna uma propriedade do objeto
2. **Métodos de instância**: insert(), update(), delete() operam na instância atual
3. **Finders estáticos**: Métodos estáticos para carregar instâncias do banco de dados
4. **Campo de identidade**: Armazene o ID da linha na propriedade do objeto
5. **Gerenciamento de estado**: Rastreie se o objeto é novo ou carregado
6. **Conexão com o banco**: Decida como o Gateway obtém a conexão

### Técnicas

- [**Lazy Load**](../object-relational/003_lazy-load.md): Carregue propriedades sob demanda
- [**Identity Field**](../object-relational/004_identity-field.md): Use ID para identificar a linha correspondente
- **Propriedades de Chave Estrangeira**: Armazene IDs de relacionamentos
- **Métodos Finder**: Métodos estáticos find* para consultas
- **Validação**: Validações básicas antes de salvar
- **Optimistic Locking**: Use versão para detectar conflitos

## Usos Conhecidos

- **Ruby on Rails (parcial)**: ActiveRecord tem aspectos de Row Gateway
- **.NET DataRow**: DataRow no ADO.NET funciona como Row Gateway
- **Bibliotecas Python**: Algumas bibliotecas ORM leves usam o padrão
- **Aplicações CRUD**: Aplicações simples de manutenção de dados
- **Prototipagem**: Protótipos rápidos com acesso a dados simples
- **Wrappers de Sistemas Legados**: Encapsulam acesso a sistemas legados

## Padrões Relacionados

- [**Table Data Gateway**](001_table-data-gateway.md): Trata múltiplas linhas; Row por linha única
- [**Active Record**](003_active-record.md): Row Gateway + lógica de negócio
- [**Data Mapper**](004_data-mapper.md): Separa completamente objetos de domínio da persistência
- [**Transaction Script**](../domain-logic/001_transaction-script.md): Usa Row Gateways para acesso a dados
- [**Table Module**](../domain-logic/003_table-module.md): Pode usar Row Gateways para carregar dados
- [**Identity Field**](../object-relational/004_identity-field.md): Técnica para identificar a linha
- [**GoF Gateway**](../base/001_gateway.md): Padrão genérico base

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): Gateway apenas para acesso
- [008 - Prohibition of Getters/Setters](../../object-calisthenics/008_proibicao-getters-setters.md): Gateway pode ter getters/setters
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): interface bem definida
- [003 - Encapsulation of Primitives](../../object-calisthenics/003_encapsulamento-primitivos.md): propriedades podem ser Value Objects

---

**Criado em**: 2025-01-11
**Versão**: 1.0
