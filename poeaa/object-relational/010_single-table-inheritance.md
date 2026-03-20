# Single Table Inheritance

**Tipo**: Padrão Object-Relational (Estrutural)

---

## Intenção e Objetivo

Representar uma hierarquia de herança de classes em uma única tabela do banco de dados que contém colunas para todos os campos de todas as classes da hierarquia, usando uma coluna discriminadora para identificar o tipo de cada registro.

## Também Conhecido Como

- Single Table Strategy
- Table-per-Hierarchy
- Discriminator Column Pattern

---

## Motivação

Ao mapear hierarquias de herança orientada a objetos para bancos de dados relacionais, enfrentamos o desafio de que bancos relacionais não possuem um conceito nativo de herança. O Single Table Inheritance resolve esse problema da forma mais simples possível: criando uma única tabela que contém todas as colunas necessárias para representar todos os atributos de todas as classes da hierarquia.

Por exemplo, considere uma hierarquia `Animal` com subclasses `Dog` e `Cat`. Dog possui um atributo `breed`, enquanto Cat possui `furColor`. Com Single Table Inheritance, criamos uma tabela `animals` com colunas: `id`, `type` (discriminador), `name`, `breed`, `furColor`. Um registro Dog teria `type='Dog'` e `furColor=NULL`, enquanto um Cat teria `type='Cat'` e `breed=NULL`.

A simplicidade do padrão vem com compensações. Como todas as subclasses compartilham a mesma tabela, colunas que pertencem apenas a uma subclasse ficam NULL para registros de outras subclasses. Isso viola a normalização e desperdiça espaço se houver muitos campos específicos de subclasse. Porém, a simplicidade das queries (tabela única, sem joins) e a facilidade de adicionar novas subclasses (apenas adicionar colunas) tornam esse padrão atraente para hierarquias simples.

---

## Aplicabilidade

Use Single Table Inheritance quando:

- A hierarquia de herança é relativamente rasa (2 a 3 níveis) com poucas subclasses
- As subclasses possuem campos similares ou compartilham a maioria dos atributos
- Você precisa fazer queries frequentes envolvendo toda a hierarquia (ex.: "todos os animais")
- A performance de leitura é crítica e você quer evitar joins
- As subclasses mudam raramente, mas novos tipos podem ser adicionados ocasionalmente
- O número de colunas específicas de subclasse é pequeno (desperdício de espaço aceitável)

---

## Estrutura

```
┌─────────────────────────────────────────────────────────────┐
│                        Código Cliente                        │
└────────────────────────────────┬────────────────────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   <<abstract>>          │
                    │      Animal             │
                    │ ─────────────────────   │
                    │ - id: Long              │
                    │ - name: String          │
                    │ + makeSound(): void     │
                    └──────────┬──────────────┘
                               │
                ┌──────────────┴──────────────┐
                │                             │
    ┌───────────▼──────────┐      ┌──────────▼──────────┐
    │   Dog                │      │   Cat               │
    │ ──────────────────   │      │ ──────────────────  │
    │ - breed: String      │      │ - furColor: String  │
    │ + bark(): void       │      │ + meow(): void      │
    └──────────────────────┘      └─────────────────────┘

Schema do Banco de Dados:
┌─────────────────────────────────────────────────────────────┐
│                     Tabela: animals                          │
├──────────┬───────────┬───────────┬──────────┬──────────────┤
│ id (PK)  │ type      │ name      │ breed    │ furColor     │
│ BIGINT   │ VARCHAR   │ VARCHAR   │ VARCHAR  │ VARCHAR      │
├──────────┼───────────┼───────────┼──────────┼──────────────┤
│ 1        │ Dog       │ Rex       │ Labrador │ NULL         │
│ 2        │ Cat       │ Felix     │ NULL     │ Black        │
│ 3        │ Dog       │ Buddy     │ Poodle   │ NULL         │
└──────────┴───────────┴───────────┴──────────┴──────────────┘
```

---

## Participantes

- **Animal** (Classe Base Abstrata): Define a interface comum e atributos compartilhados para todas as subclasses da hierarquia.

- **Dog / Cat** (Subclasses Concretas): Implementam comportamentos específicos e possuem atributos adicionais armazenados em colunas dedicadas na tabela compartilhada.

- **Coluna Discriminadora** (`type`): Coluna especial na tabela que armazena o tipo de classe concreta de cada registro, permitindo que o ORM instancie a classe correta ao carregar do banco de dados.

- **Mapper/ORM**: Componente responsável por ler a coluna discriminadora, instanciar a classe correta e popular apenas os campos relevantes para aquele tipo.

- **Tabela Única** (`animals`): Estrutura do banco de dados contendo a união de todas as colunas de todas as classes, com muitos valores NULL.

---

## Colaborações

Quando o cliente solicita o salvamento de um objeto Dog, o Mapper verifica o tipo do objeto, define a coluna `type='Dog'`, preenche as colunas compartilhadas (`id`, `name`) e a coluna específica (`breed`), deixando `furColor` como NULL. A operação é um simples INSERT em uma única tabela.

Ao carregar, o Mapper executa um SELECT, lê a coluna `type` e, com base no valor, instancia a classe apropriada (Dog ou Cat), populando apenas os campos relevantes para aquela classe. Queries polimórficas ("SELECT * FROM animals") retornam todos os registros de todos os tipos com uma única instrução.

---

## Consequências

### Vantagens

1. **Simplicidade do Schema**: Apenas uma tabela para toda a hierarquia — fácil de entender e manter.
2. **Performance de Leitura**: Queries não requerem joins — todos os dados estão em uma única tabela.
3. **Queries Polimórficas Simples**: Buscar todos os objetos da hierarquia é trivial (SELECT sem joins).
4. **Facilidade de Refatoração**: Mover campos entre classes não requer mudanças no schema, apenas alterações no código.
5. **Adição de Novas Subclasses**: Adicionar um novo tipo requer apenas novas colunas (ALTER TABLE) e um novo valor discriminador.
6. **Transações Simples**: Salvar ou atualizar um objeto é uma única operação de escrita.

### Desvantagens

1. **Violação de Normalização**: Muitas colunas ficam NULL para registros que não as utilizam, desperdiçando espaço.
2. **Poluição do Schema**: A tabela cresce horizontalmente com cada nova subclasse, tornando-se difícil de gerenciar.
3. **Impossibilidade de NOT NULL**: Colunas específicas de subclasse não podem ter restrições NOT NULL, pois outras subclasses as deixarão NULL.
4. **Desperdício de Espaço**: Em bancos que alocam espaço para colunas NULL, o overhead de armazenamento pode ser significativo.
5. **Dificuldade de Entender o Modelo**: Para quem lê o schema, não é óbvio quais colunas pertencem a quais classes sem consultar o código.

---

## Implementação

### Considerações de Implementação

1. **Escolha do Discriminador**: O discriminador pode ser o nome da classe (String), um código numérico ou um enum. Strings são mais legíveis; números economizam espaço.

2. **Indexação do Discriminador**: Sempre criar um índice na coluna discriminadora, pois queries frequentemente filtram por tipo específico.

3. **Estratégia NULL vs. Valores Padrão**: Decidir se colunas não utilizadas ficam NULL ou recebem valores padrão. NULL é mais explícito, mas valores padrão podem evitar verificações.

4. **Validação de Integridade**: Implementar validações no código para garantir que apenas as colunas corretas sejam preenchidas para cada tipo.

5. **Limite de Colunas**: Bancos possuem limites de colunas por tabela (MySQL: 4096, PostgreSQL: 1600). Planeje para não exceder esses limites.

6. **Migração de Dados**: Ao adicionar novas subclasses, planeje migrações que adicionam colunas com valores NULL padrão para registros existentes.

### Técnicas de Implementação

1. **Discriminator Mapping**: Configurar o ORM para mapear valores discriminadores para classes. No Hibernate: `@DiscriminatorColumn(name="type")` e `@DiscriminatorValue("Dog")`.

2. **Herança de Mappers**: Usar o padrão Inheritance Mappers onde cada Mapper de subclasse herda do Mapper base, reutilizando o código de mapeamento de campos comuns.

3. **Lazy Loading Seletivo**: Configurar lazy loading para coleções ou objetos grandes dentro da hierarquia para evitar carregar dados desnecessários.

4. **Estratégia de Leitura**: Usar SELECT específico por tipo quando possível (`WHERE type='Dog'`) para evitar overhead de processar tipos desnecessários.

5. **Cache Discriminado**: Configurar cache de segundo nível separado por tipo para evitar invalidações desnecessárias de cache.

6. **Colunas de Auditoria**: Adicionar colunas de auditoria (`created_at`, `updated_at`, `version`) uma vez na tabela base, aplicando a todos os tipos.

---

## Usos Conhecidos

1. **Hibernate ORM**: Suporta Single Table Inheritance via estratégia `InheritanceType.SINGLE_TABLE` com `@DiscriminatorColumn`.

2. **Entity Framework (C#)**: A estratégia TPH (Table-per-Hierarchy) é o padrão para mapeamento de herança.

3. **Rails Active Record**: Usa Single Table Inheritance (STI) como padrão para hierarquias, com coluna `type` como discriminador automático.

4. **Django ORM**: Não suporta nativamente, mas pode ser implementado com classes base abstratas e seleção manual de tipo.

5. **Doctrine (PHP)**: Suporta Single Table Inheritance com a anotação `@InheritanceType("SINGLE_TABLE")`.

6. **Sistemas de E-commerce**: Usam STI para representar diferentes tipos de Product (Físico, Digital, Serviço) em uma tabela com discriminador.

---

## Padrões Relacionados

- [**Class Table Inheritance**](011_class-table-inheritance.md): Alternativa que cria uma tabela por classe, evitando NULLs mas exigindo joins.
- [**Concrete Table Inheritance**](012_concrete-table-inheritance.md): Alternativa que cria tabela apenas para classes concretas, duplicando campos herdados.
- [**Inheritance Mappers**](013_inheritance-mappers.md): Estrutura Mappers para refletir a hierarquia de herança dos objetos.
- [**Identity Field**](004_identity-field.md): Usado para identificar unicamente cada registro na tabela compartilhada.
- [**Lazy Load**](003_lazy-load.md): Pode ser usado para evitar carregar campos específicos de subclasse desnecessariamente.
- [**Query Object**](015_query-object.md): Facilita a criação de queries que filtram por tipo específico usando o discriminador.
- [**Repository**](016_repository.md): Encapsula a lógica para criar queries polimórficas sobre a hierarquia.

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): organizar hierarquia
- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): extensão via subclasses

---

## Relação com Regras de Negócio

- **[012] Liskov Substitution Principle**: Single Table Inheritance facilita o polimorfismo ao permitir queries que retornam uma mistura de subclasses.
- **[022] Priorização de Simplicidade e Clareza**: É o padrão de mapeamento de herança mais simples — ideal quando a simplicidade é prioridade.
- **[010] Single Responsibility Principle**: Cada Mapper de subclasse é responsável apenas pelos seus campos específicos.
- **[019] Stable Dependencies Principle**: A tabela única é estável — adicionar subclasses não quebra as queries existentes.

---

**Criado em**: 2025-01-10
**Versão**: 1.0
