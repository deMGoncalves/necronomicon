# Inheritance Mappers

**Tipo**: Padrão Object-Relational (Estrutural)

---

## Intenção e Objetivo

Estruturar Data Mappers de forma que reflita a hierarquia de herança dos objetos de domínio sendo mapeados, permitindo a reutilização de código de mapeamento comum por meio da herança de Mappers.

## Também Conhecido Como

- Hierarchical Mappers
- Mapper Inheritance
- Layered Mappers

---

## Motivação

Ao usar o padrão Data Mapper com uma hierarquia de objetos de domínio (ex.: Animal → Dog, Cat), surge a questão de como estruturar os Mappers. Uma abordagem seria criar Mappers completamente independentes para cada classe, mas isso levaria a uma enorme duplicação de código — cada Mapper repetiria a lógica para mapear os campos comuns (id, name) definidos na superclasse Animal.

O Inheritance Mappers resolve esse problema fazendo os Mappers espelharem a hierarquia de herança do domínio: criar um `AbstractAnimalMapper` que sabe mapear os campos comuns, e então `DogMapper` e `CatMapper` herdam dele, adicionando apenas o código para mapear seus campos específicos. Isso maximiza a reutilização e mantém o DRY.

O padrão funciona com qualquer estratégia de mapeamento de herança (Single Table, Class Table, Concrete Table). Por exemplo, com Class Table Inheritance, o `AbstractAnimalMapper` mapeia a tabela `animals`, e `DogMapper` herda e adiciona lógica para fazer JOIN e mapear a tabela `dogs`. A estrutura de herança dos Mappers desacopla a lógica de mapeamento da estratégia de schema.

---

## Aplicabilidade

Use Inheritance Mappers quando:

- Você está usando o padrão Data Mapper (não Active Record) com hierarquias de objetos
- Classes na hierarquia compartilham campos comuns que seriam duplicados se cada Mapper fosse independente
- A lógica de mapeamento (queries, transformações) possui partes comuns que podem ser abstraídas
- Você quer que mudanças na superclasse do domínio reflitam automaticamente em todos os Mappers de subclasse
- A hierarquia do domínio é estável — refatorações de herança são raras
- Você quer manter a lógica de mapeamento organizada de forma que reflita a estrutura do domínio

---

## Estrutura

```
Camada de Domínio:
┌──────────────────────────────────────────────────────────┐
│                    <<abstract>>                          │
│                       Animal                             │
│ ──────────────────────────────────────────────────────   │
│ - id: Long                                               │
│ - name: String                                           │
└────────────────────────┬─────────────────────────────────┘
                         │
          ┌──────────────┴──────────────┐
          │                             │
┌─────────▼──────────┐        ┌─────────▼──────────┐
│   Dog              │        │   Cat              │
│ ────────────────   │        │ ────────────────   │
│ - breed: String    │        │ - furColor: String │
└────────────────────┘        └────────────────────┘

Camada de Mapper:
┌──────────────────────────────────────────────────────────┐
│             <<abstract>>                                 │
│          AbstractAnimalMapper                            │
│ ──────────────────────────────────────────────────────   │
│ # mapCommonFields(rs: ResultSet, animal: Animal)         │
│ # insertCommonFields(animal: Animal): Long               │
│ + find(id: Long): Animal  {abstract}                     │
└────────────────────────┬─────────────────────────────────┘
                         │
          ┌──────────────┴──────────────┐
          │                             │
┌─────────▼──────────┐        ┌─────────▼──────────┐
│  DogMapper         │        │  CatMapper         │
│ ────────────────   │        │ ────────────────   │
│ + find(id): Dog    │        │ + find(id): Cat    │
│ + insert(d: Dog)   │        │ + insert(c: Cat)   │
│ - mapBreed(rs)     │        │ - mapColor(rs)     │
└────────────────────┘        └────────────────────┘
```

---

## Participantes

- **AbstractAnimalMapper** (Mapper Base Abstrato): Contém a lógica compartilhada para mapear campos comuns (id, name). Pode ter template methods que definem o fluxo geral de find/insert/update, deixando os detalhes para as subclasses.

- **DogMapper / CatMapper** (Mappers Concretos): Herdam do Mapper base e implementam a lógica específica para mapear campos adicionais (breed, furColor). Podem chamar métodos protegidos da superclasse.

- **Domain Objects** (Animal, Dog, Cat): Os objetos de domínio sendo mapeados. A hierarquia de Mappers espelha a hierarquia de domínio.

- **Schema do Banco de Dados**: Pode usar qualquer estratégia (Single Table, Class Table, Concrete Table). O padrão Inheritance Mappers é independente da estratégia de schema.

- **Template Methods**: Métodos no Mapper superclasse que definem o esqueleto do algoritmo de mapeamento, delegando etapas específicas para as subclasses.

---

## Colaborações

Quando o cliente requisita `dogMapper.find(id)`, o DogMapper executa a query específica (que pode incluir JOIN se usar Class Table). Ao construir o objeto Dog a partir do ResultSet, ele chama `mapCommonFields(rs, dog)` herdado do AbstractAnimalMapper para popular id e name, e depois adiciona sua própria lógica para popular breed.

Na operação de inserção, o DogMapper primeiro chama `super.insertCommonFields(dog)` que insere na tabela `animals` e retorna o ID gerado. Então usa esse ID para inserir na tabela `dogs` com os campos específicos. O fluxo é coordenado pela herança dos Mappers.

---

## Consequências

### Vantagens

1. **Reutilização de Código**: A lógica de mapeamento para campos comuns é escrita uma vez no Mapper superclasse.
2. **DRY no Mapeamento**: Evita duplicação de código de mapeamento entre Mappers de subclasse.
3. **Manutenibilidade**: Mudanças nos campos do domínio da superclasse requerem mudanças apenas no Mapper base.
4. **Estrutura Clara**: A hierarquia de Mappers espelha o domínio, facilitando a navegação e compreensão.
5. [**Template Method**](../../gof/behavioral/010_template-method.md): Permite definir fluxos complexos de mapeamento na superclasse com hooks para subclasses.
6. **Flexibilidade de Schema**: Funciona com qualquer estratégia de herança de schema (Single/Class/Concrete Table).

### Desvantagens

1. **Acoplamento por Herança**: Mappers ficam fortemente acoplados à hierarquia de domínio — refatorações de herança requerem mudanças nos Mappers.
2. **Complexidade de Depuração**: O fluxo de execução cruza múltiplos níveis de herança, dificultando a depuração.
3. **Fragilidade da Classe Base**: Mudanças no AbstractMapper podem quebrar todos os Mappers de subclasse.
4. **Limitações de Linguagem**: Em linguagens sem herança múltipla, Mappers não podem herdar de múltiplas fontes se necessário.
5. **Dificuldade de Testes**: Testar Mappers concretos requer setup dos Mappers base, aumentando a complexidade dos testes.

---

## Implementação

### Considerações de Implementação

1. **Métodos Protegidos**: Usar visibilidade `protected` para métodos auxiliares de mapeamento que devem ser acessíveis pelas subclasses mas não pelos clientes.

2. **Padrão Template Method**: Estruturar métodos principais (find, insert) como templates na superclasse com hooks (métodos abstratos) para as subclasses preencherem.

3. **Inicialização da Superclasse**: Construtores de Mappers concretos devem chamar construtores da superclasse para garantir inicialização adequada (ex.: connection pool).

4. **Identity Map Compartilhado**: Se usar Identity Map, compartilhar uma instância entre Mappers da hierarquia para evitar múltiplas instâncias do mesmo objeto.

5. **Tratamento de Exceções**: Centralizar o tratamento de exceções de banco de dados no Mapper superclasse quando possível.

6. **Injeção de Dependência**: Injetar dependências (DataSource, conexões) no Mapper base e propagar às subclasses.

### Técnicas de Implementação

1. **Método Find Abstrato**: Definir `find(id)` como abstrato no Mapper base, forçando cada Mapper concreto a implementar sua própria query.

2. **Mappers de Campo Protegidos**: Criar métodos como `protected void mapId(ResultSet rs, Animal animal)` na superclasse para serem reutilizados.

3. **Strategy para Schema**: Usar padrão Strategy para lógica específica de schema (Single Table vs Class Table), mantendo os Mappers independentes da estratégia.

4. **Inicialização Lazy**: Mappers concretos podem usar inicialização lazy para criar instâncias de Mappers relacionados (ex.: endereço) apenas quando necessário.

5. **Reflection para Instanciação**: Usar reflection na superclasse para instanciar objetos de domínio do tipo correto, evitando duplicação de código de instanciação.

6. **Query Builders**: Encapsular a construção de queries em métodos auxiliares na superclasse (ex.: `buildSelectCommonFields()`) que subclasses podem estender.

---

## Usos Conhecidos

1. **MyBatis Mapper Inheritance**: MyBatis permite que mappers XML herdem de mappers base, reutilizando fragmentos SQL comuns.

2. **ORMs Customizados em Sistemas Corporativos**: Grandes sistemas financeiros frequentemente implementam Inheritance Mappers para hierarquias de Instrumentos Financeiros.

3. **Rails + Repository Pattern**: Aplicações Rails que usam Repository em vez de Active Record frequentemente implementam repositories hierárquicos.

4. **Java Persistence Frameworks**: Frameworks como iBatis e primeiras versões do Hibernate encorajavam a estruturação de Mappers em hierarquias.

5. **Entity Framework Migrations**: Migrações do EF podem ser estruturadas em hierarquia para compartilhar migrações base.

6. **Doctrine ORM (PHP)**: Suporta mapeamento hierárquico onde mappers de entidades filhas referenciam configurações do mapper pai.

---

## Padrões Relacionados

- [**Data Mapper**](../data-source/004_data-mapper.md): Inheritance Mappers é uma especialização do Data Mapper para hierarquias de objetos.
- [**GoF Template Method**](../../gof/behavioral/010_template-method.md): Usado extensivamente para definir o esqueleto dos algoritmos de mapeamento no Mapper superclasse.
- [**GoF Strategy**](../../gof/behavioral/009_strategy.md): Pode complementar para trocar estratégias de schema (Single/Class/Concrete Table) sem alterar os Mappers.
- [**Layer Supertype**](../base/003_layer-supertype.md): AbstractMapper é um Layer Supertype para todos os Mappers da aplicação.
- [**Single Table Inheritance**](010_single-table-inheritance.md): Inheritance Mappers funciona bem com STI — superclasse mapeia tabela única e discriminador.
- [**Class Table Inheritance**](011_class-table-inheritance.md): Mappers herdam e adicionam lógica de JOIN para mapear as tabelas de subclasse.
- [**Registry**](../base/005_registry.md): Mappers podem ser registrados em um Registry para busca dinâmica por tipo de domínio.

### Relação com Rules

- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): mappers abstratos
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): um mapper por hierarquia

---

## Relação com Regras de Negócio

- **[021] Proibição de Duplicação de Lógica**: Inheritance Mappers elimina a duplicação de lógica de mapeamento de campos comuns.
- **[010] Single Responsibility Principle**: Cada Mapper tem a única responsabilidade de mapear sua classe de domínio.
- **[014] Dependency Inversion Principle**: Mappers Abstratos dependem de abstrações (interfaces), não de Mappers concretos.
- **[022] Priorização de Simplicidade e Clareza**: Estrutura hierárquica clara reflete e documenta o domínio.

---

**Criado em**: 2025-01-10
**Versão**: 1.0
