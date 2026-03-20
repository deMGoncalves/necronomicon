# Active Record

**Classificação**: Padrão Arquitetural de Fonte de Dados

---

## Intenção e Objetivo

Um objeto que encapsula uma linha em uma tabela de banco de dados, encapsula o acesso ao banco de dados e adiciona lógica de domínio sobre esses dados. O objeto sabe como persistir a si mesmo.

## Também Conhecido Como

- Self-Persistent Object
- Smart Record
- Domain Object with Persistence

## Motivação

O Active Record combina dados e comportamento em um único objeto, onde o objeto representa uma linha do banco de dados e contém tanto lógica de domínio quanto lógica de persistência. É uma abordagem intuitiva que reduz a incompatibilidade objeto-relacional ao fazer o objeto "saber" como salvar a si mesmo.

Considere um objeto Person: ele possui propriedades (name, email, age) correspondentes às colunas, métodos de negócio (sendEmail(), calculateAge()) implementando a lógica, e métodos de persistência (save(), delete(), find()) interagindo com o banco de dados. O client usa Person como um objeto de domínio rico sem se preocupar com detalhes de persistência.

Essa simplicidade torna o Active Record extremamente popular em frameworks web como Ruby on Rails e Laravel. Para aplicações com lógica de domínio de complexidade moderada e mapeamento direto entre objetos e tabelas, o Active Record oferece produtividade significativa sem a complexidade de camadas de persistência separadas.

## Aplicabilidade

Use Active Record quando:

- A lógica de domínio tem complexidade baixa a moderada
- A estrutura do objeto mapeia diretamente para a estrutura da tabela
- Os relacionamentos são relativamente simples
- A produtividade rápida é mais importante do que a separação estrita
- O framework escolhido (Rails, Laravel) usa Active Record por padrão
- A equipe prefere uma abordagem pragmática à separação arquitetural rigorosa

## Estrutura

```
Client (Aplicação/UI)
└── Usa: objetos Active Record

Active Record (objetos de domínio + persistência)
├── Person (Active Record)
│   ├── Propriedades: id, name, email, age
│   ├── Métodos de Negócio:
│   │   ├── sendEmail()
│   │   ├── isAdult()
│   │   └── updateProfile(data)
│   ├── Métodos de Persistência:
│   │   ├── save(): persiste o objeto
│   │   ├── delete(): remove do banco de dados
│   │   ├── reload(): recarrega do banco de dados
│   │   └── validates(): valida antes de salvar
│   └── Métodos Estáticos (Finders):
│       ├── find(id): Person
│       ├── findByEmail(email): Person
│       └── all(): Person[]
│
├── Order (Active Record)
│   ├── Propriedades: id, customerId, date, total
│   ├── Métodos de Negócio:
│   │   ├── calculateTotal()
│   │   ├── addItem(product, quantity)
│   │   └── cancel()
│   └── Métodos de Persistência:
│       ├── save()
│       └── delete()
│
└── Product (Active Record)
    ├── Propriedades: id, name, price, stock
    ├── Métodos de Negócio:
    │   ├── isAvailable()
    │   └── adjustStock(quantity)
    └── Métodos de Persistência:
        └── save()

Banco de Dados
└── Tabelas espelhadas pelas classes Active Record
```

## Participantes

- **Classe Active Record**: Classe que representa a tabela; combina dados, lógica e persistência
- **Propriedades**: Campos correspondentes às colunas da tabela
- **Métodos de Negócio**: Métodos que implementam a lógica de domínio
- **Métodos de Persistência**: save(), delete(), reload() para persistência
- **Métodos Finder**: Métodos estáticos para consultas (find, where, all)
- **Conexão com o Banco de Dados**: Conexão usada para executar o SQL
- **Validações**: Regras de validação antes de persistir

## Colaborações

- O Client cria uma nova instância de Active Record ou a obtém via finder
- Para criar: o Client instancia o objeto, define as propriedades e chama save()
- O Active Record valida os dados e executa o INSERT SQL
- Para carregar: o Client chama Person.find(5) (método estático)
- O finder executa o SELECT, cria a instância, popula as propriedades e retorna o objeto
- O Client invoca métodos de negócio no objeto carregado
- Para atualizar: o Client modifica as propriedades ou chama métodos de negócio
- O Client chama save(); o Active Record executa o UPDATE SQL
- Para deletar: o Client chama delete(); o Active Record executa o DELETE SQL

## Consequências

### Vantagens

- **Simplicidade**: Abordagem direta e intuitiva; fácil de aprender
- **Produtividade**: Desenvolvimento rápido com menos código boilerplate
- **Conveniência**: O objeto sabe como persistir a si mesmo
- **Integração**: Bem integrado com frameworks web modernos
- **Menos classes**: Não requer classes separadas para mapeamento
- **CRUD direto**: Operações CRUD extremamente simples

### Desvantagens

- **Acoplamento**: Lógica de domínio acoplada à persistência e ao esquema do banco de dados
- **Dificuldade de teste**: Difícil testar lógica de negócio sem banco de dados
- **Complexidade limitada**: Não escala bem para domínios muito complexos
- **Incompatibilidade**: Difícil tratar mapeamentos OO complexos
- **Mudanças no esquema**: Alterações no banco de dados afetam os objetos de domínio
- **Separação fraca**: Viola o princípio de separação de responsabilidades

## Implementação

### Considerações

1. **Herança de classe base**: Active Records geralmente herdam de uma classe base comum
2. **Convenção sobre configuração**: Use convenções para mapear classes a tabelas
3. **Finders**: Implemente métodos estáticos para consultas comuns
4. **Validações**: Defina validações executadas antes de save()
5. **Callbacks**: Hooks para before_save, after_create, etc
6. **Relacionamentos**: Declare has_many, belongs_to, etc

### Técnicas

- **Convenção sobre Configuração**: O nome da classe mapeia para o nome da tabela
- **Atributos Automáticos**: Propriedades geradas automaticamente a partir das colunas
- **Métodos Finder**: find(), where(), all() para consultas
- **Associações**: Declare relacionamentos (has_many, belongs_to)
- **Validações**: Validações declarativas antes de persistir
- **Callbacks**: Hooks de ciclo de vida (before_save, after_create)
- **Scopes**: Escopos nomeados para consultas reutilizáveis

## Usos Conhecidos

- **Ruby on Rails**: ActiveRecord é o ORM padrão do Rails
- **Laravel/Eloquent**: ORM do framework Laravel (PHP)
- **Castle ActiveRecord**: Active Record para .NET
- **Django Models**: Os models do Django têm características de Active Record
- **Yii Framework**: Active Record do framework PHP
- **RedBeanPHP**: ORM Active Record para PHP

## Padrões Relacionados

- [**Row Data Gateway**](002_row-data-gateway.md): Active Record adiciona lógica de negócio
- [**Data Mapper**](004_data-mapper.md): Separa completamente objetos da persistência
- [**Domain Model**](../domain-logic/002_domain-model.md): Active Record é uma forma simples de Domain Model
- [**Table Data Gateway**](001_table-data-gateway.md): Alternativa sem lógica de negócio
- [**Unit of Work**](../object-relational/001_unit-of-work.md): Pode ser combinado para gerenciar transações
- [**Identity Map**](../object-relational/002_identity-map.md): Pode ser adicionado para garantir identidade única
- [**Repository**](../object-relational/016_repository.md): Alternativa que encapsula a persistência

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): violação; mistura responsabilidades
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): domínio depende da persistência
- [032 - Test Coverage](../../clean-code/cobertura-teste-minima-qualidade.md): dificulta testes unitários
- [022 - Prioritization of Simplicity](../../clean-code/priorizacao-simplicidade-clareza.md): simples para casos moderados

---

**Criado em**: 2025-01-11
**Versão**: 1.0
