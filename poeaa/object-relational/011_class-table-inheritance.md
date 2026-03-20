# Class Table Inheritance

**Tipo**: Padrão Object-Relational (Estrutural)

---

## Intenção e Objetivo

Representar uma hierarquia de herança de classes com uma tabela do banco de dados para cada classe da hierarquia, onde cada tabela contém apenas os campos definidos naquela classe específica.

## Também Conhecido Como

- Table-per-Class
- Joined Strategy
- Normalized Inheritance Mapping

---

## Motivação

O Single Table Inheritance é simples, mas sofre com desperdício de espaço e impossibilidade de restrições NOT NULL em campos específicos de subclasse. O Class Table Inheritance resolve esses problemas por meio da normalização: cada classe da hierarquia possui sua própria tabela contendo apenas seus campos específicos.

Considere a hierarquia `Animal` → `Dog`, `Cat`. Com Class Table Inheritance, criamos três tabelas: `animals` (id, name), `dogs` (id FK→animals, breed), `cats` (id FK→animals, furColor). Um registro Dog possui uma linha em `animals` e outra em `dogs`, ligadas por chave estrangeira. Isso elimina colunas NULL e permite restrições apropriadas (ex.: `breed NOT NULL` em `dogs`).

A vantagem é a normalização perfeita — sem desperdício de espaço, cada tabela possui semântica clara e o schema reflete diretamente a estrutura de herança. O custo é a complexidade: queries requerem joins para reconstruir o objeto completo, e a performance de leitura pode degradar em hierarquias profundas. A escolha entre Single Table e Class Table é um clássico trade-off entre simplicidade/performance e normalização/integridade.

---

## Aplicabilidade

Use Class Table Inheritance quando:

- A hierarquia possui muitos campos específicos de subclasse que raramente são compartilhados
- Integridade referencial e restrições NOT NULL são importantes para o domínio
- Queries frequentemente operam em uma única subclasse (ex.: "todos os dogs")
- A normalização do schema é uma prioridade arquitetural
- A hierarquia é profunda (mais de 3 níveis) e o desperdício de colunas NULL seria significativo
- O modelo de dados precisa ser compreensível sem consultar o código (schema auto-documentado)

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
┌──────────────────────────┐
│   Tabela: animals        │
├──────────┬───────────────┤
│ id (PK)  │ name          │
│ BIGINT   │ VARCHAR       │
├──────────┼───────────────┤
│ 1        │ Rex           │
│ 2        │ Felix         │
│ 3        │ Buddy         │
└──────────┴───────────────┘
         △
         │ FK
         │
┌────────┴─────────────────┐
│                          │
│  Tabela: dogs            │    Tabela: cats
├──────────┬───────────────┤    ├──────────┬──────────────┤
│ id (PK)  │ breed         │    │ id (PK)  │ furColor     │
│ FK       │ VARCHAR       │    │ FK       │ VARCHAR      │
├──────────┼───────────────┤    ├──────────┼──────────────┤
│ 1        │ Labrador      │    │ 2        │ Black        │
│ 3        │ Poodle        │    └──────────┴──────────────┘
└──────────┴───────────────┘
```

---

## Participantes

- **Animal** (Tabela Base): Armazena o ID primário e todos os campos comuns a toda a hierarquia. Serve como âncora para as chaves estrangeiras das tabelas de subclasse.

- **Dog / Cat** (Tabelas de Subclasse): Armazenam apenas os campos específicos de cada subclasse. Suas chaves primárias são simultaneamente chaves estrangeiras para a tabela base.

- **Relacionamento de Chave Estrangeira**: Liga cada registro de subclasse ao registro correspondente na tabela base, garantindo a integridade referencial.

- **Mapper/ORM**: Responsável por coordenar JOINs entre tabelas para reconstruir o objeto completo ao carregar, e por INSERT/UPDATE em múltiplas tabelas ao salvar.

- [**Identity Field**](004_identity-field.md): O ID é compartilhado por todas as tabelas — o mesmo valor de ID identifica o mesmo objeto em todas as tabelas da hierarquia.

---

## Colaborações

Ao salvar um objeto Dog, o Mapper primeiro insere um registro na tabela `animals` com os campos comuns (name) e obtém o ID gerado. Em seguida, insere na tabela `dogs` usando esse mesmo ID como chave primária e chave estrangeira, incluindo os campos específicos (breed). A operação requer duas escritas coordenadas.

Ao carregar um Dog por ID, o Mapper executa um JOIN entre `animals` e `dogs` (`SELECT * FROM animals INNER JOIN dogs ON animals.id = dogs.id WHERE animals.id = ?`), recupera os dados de ambas as tabelas e constrói o objeto Dog completo com todos os campos.

---

## Consequências

### Vantagens

1. **Normalização Perfeita**: Sem colunas NULL desnecessárias — cada tabela contém apenas dados relevantes.
2. **Restrições de Integridade**: Campos de subclasse podem ter restrições NOT NULL, UNIQUE, CHECK apropriadas.
3. **Schema Auto-Documentado**: A estrutura de tabelas reflete diretamente a hierarquia de classes, facilitando a compreensão.
4. **Economia de Espaço**: Sem desperdício de armazenamento com colunas vazias.
5. **Evolução Independente**: Adicionar campos a uma subclasse não afeta outras tabelas da hierarquia.
6. **Suporte a Extensão**: Fácil adicionar novas subclasses sem poluir tabelas existentes.

### Desvantagens

1. **Performance de Leitura**: Cada carregamento de objeto requer JOIN de múltiplas tabelas, degradando a performance.
2. **Complexidade de Query**: Queries polimórficas ("todos os animais") requerem UNION ou múltiplos LEFT JOINs.
3. **Overhead de Escrita**: Salvar um objeto requer múltiplos INSERTs/UPDATEs coordenados, aumentando a chance de erro.
4. **Problemas de Refatoração**: Mover um campo entre superclasse e subclasse requer migração de dados entre tabelas.
5. **Hierarquias Profundas**: Em hierarquias com 5+ níveis, o número de JOINs pode tornar as queries impraticáveis.

---

## Implementação

### Considerações de Implementação

1. **Estratégia de Chave Primária**: A PK da tabela de subclasse deve ser simultaneamente FK para a tabela base. Use `ON DELETE CASCADE` para manter a integridade.

2. **Identificação de Tipo**: Sem coluna discriminadora explícita, o ORM identifica o tipo pela presença de registro na tabela de subclasse após os JOINs.

3. **Ordenação de Operações**: Ao salvar, sempre inserir primeiro na superclasse (para obter o ID), depois nas subclasses. Ao excluir, excluir das subclasses primeiro.

4. **Transações**: Operações em múltiplas tabelas devem ser encapsuladas em transações para garantir atomicidade (ou tudo é salvo, ou nada é).

5. **Índices**: Criar índices nas chaves estrangeiras das tabelas de subclasse para otimizar os JOINs.

6. **Views**: Para queries polimórficas frequentes, considerar criar views que façam UNION de todas as subclasses.

### Técnicas de Implementação

1. **Mapeamento ORM**: Hibernate usa `@Inheritance(strategy = InheritanceType.JOINED)`. Entity Framework usa `Table-per-Type` (TPT).

2. **SQL com Herança**: Usar Common Table Expressions (CTEs) para queries hierárquicas complexas.

3. **Lazy Loading de Subclasses**: Configurar o ORM para carregar lazily as propriedades de subclasse se não forem necessárias imediatamente.

4. **Batch Fetching**: Usar batch fetching (solução para o problema N+1 SELECT) para carregar múltiplos objetos de subclasse eficientemente.

5. **Polimorfismo via UNION**: Para "SELECT all", usar `SELECT id, name, 'Dog' as type FROM animals JOIN dogs UNION SELECT id, name, 'Cat' as type FROM animals JOIN cats`.

6. **Tabela Abstrata**: Se a superclasse for abstrata, a tabela base pode ser mantida apenas para integridade referencial, sem registros "órfãos".

---

## Usos Conhecidos

1. **Hibernate ORM**: A estratégia `JOINED` é amplamente utilizada em sistemas corporativos que priorizam a normalização.

2. **Entity Framework**: TPT (Table-per-Type) é uma das três estratégias padrão de mapeamento de herança.

3. **Sistemas Financeiros**: Usam Class Table para hierarquias de Instrumento Financeiro (Ação, Título, Derivativo) onde cada tipo possui campos específicos.

4. **Sistemas de RH**: Mapeiam hierarquia de Funcionário → Gerente, Desenvolvedor, Vendedor com tabela por tipo.

5. **Plataformas de E-commerce**: Usam para Produtos → ProdutoFísico, ProdutoDigital, Assinatura, onde cada tipo possui logística diferente.

6. **PostgreSQL Inheritance**: O PostgreSQL possui suporte nativo para herança de tabelas (`CREATE TABLE dogs (...) INHERITS (animals)`), implementando este padrão no nível do banco de dados.

---

## Padrões Relacionados

- [**Single Table Inheritance**](010_single-table-inheritance.md): Alternativa mais simples que usa uma única tabela com discriminador.
- [**Concrete Table Inheritance**](012_concrete-table-inheritance.md): Alternativa que duplica campos comuns em cada tabela concreta.
- [**Inheritance Mappers**](013_inheritance-mappers.md): Estrutura Mappers em hierarquia para refletir a hierarquia de objetos.
- [**Foreign Key Mapping**](005_foreign-key-mapping.md): Usado para ligar as tabelas de subclasse à tabela base.
- [**Identity Field**](004_identity-field.md): O ID é compartilhado entre as tabelas base e de subclasse.
- [**Lazy Load**](003_lazy-load.md): Essencial para evitar JOINs desnecessários ao carregar hierarquias profundas.
- [**Unit of Work**](001_unit-of-work.md): Coordena INSERTs/UPDATEs em múltiplas tabelas atomicamente.

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): tabela por responsabilidade
- [012 - Liskov Substitution Principle](../../solid/003_liskov-substitution-principle.md): subclasses substituíveis

---

## Relação com Regras de Negócio

- **[012] Liskov Substitution Principle**: A estrutura de tabelas separadas reflete a substituibilidade entre classes.
- **[010] Single Responsibility Principle**: Cada tabela tem a única responsabilidade de armazenar campos de uma classe específica.
- **[014] Dependency Inversion Principle**: O Mapper abstrai a complexidade dos JOINs, mantendo o domínio independente do schema.
- **[021] Proibição de Duplicação de Lógica**: Elimina a duplicação de colunas comuns que ocorreria no Concrete Table Inheritance.

---

**Criado em**: 2025-01-10
**Versão**: 1.0
