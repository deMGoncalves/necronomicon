# Concrete Table Inheritance

**Tipo**: Padrão Object-Relational (Estrutural)

---

## Intenção e Objetivo

Representar uma hierarquia de herança criando uma tabela do banco de dados apenas para cada classe concreta (não abstrata), onde cada tabela contém todos os campos necessários, incluindo os herdados da superclasse.

## Também Conhecido Como

- Table-per-Concrete-Class
- Leaf Table Inheritance
- Denormalized Inheritance Mapping

---

## Motivação

Tanto o Single Table quanto o Class Table Inheritance possuem desvantagens: o Single Table desperdiça espaço com NULLs, e o Class Table requer JOINs custosos. O Concrete Table Inheritance adota uma abordagem diferente: elimina completamente a tabela da superclasse abstrata e cria tabelas apenas para as classes concretas que podem ser instanciadas, duplicando os campos herdados nessas tabelas.

Considere `Animal` (abstrato) → `Dog`, `Cat`. Com Concrete Table, criamos apenas duas tabelas: `dogs` (id, name, breed) e `cats` (id, name, furColor). A coluna `name`, definida em Animal, é duplicada em ambas as tabelas. Não existe tabela `animals`.

A vantagem é a máxima performance de leitura — cada query opera em uma única tabela sem JOINs, e não há colunas NULL desperdiçadas. O custo é a duplicação de definições de colunas (violação do princípio DRY no schema) e a extrema dificuldade em queries polimórficas — buscar "todos os animais" requer UNION de tabelas desconexas.

---

## Aplicabilidade

Use Concrete Table Inheritance quando:

- A superclasse é puramente abstrata e nunca é instanciada diretamente
- Queries polimórficas são extremamente raras ou inexistentes
- Cada subclasse é consultada de forma independente, quase como se fossem entidades separadas
- A performance de leitura é absolutamente crítica e JOINs são inaceitáveis
- As subclasses possuem campos muito diferentes, com pouca sobreposição além dos herdados
- Você está disposto a aceitar duplicação no schema em troca de simplicidade nas queries

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

Schema do Banco de Dados (SEM tabela animals!):
┌────────────────────────────────────┐
│   Tabela: dogs                     │
├──────────┬───────────┬─────────────┤
│ id (PK)  │ name      │ breed       │
│ BIGINT   │ VARCHAR   │ VARCHAR     │
├──────────┼───────────┼─────────────┤
│ 1        │ Rex       │ Labrador    │
│ 3        │ Buddy     │ Poodle      │
└──────────┴───────────┴─────────────┘

┌────────────────────────────────────┐
│   Tabela: cats                     │
├──────────┬───────────┬─────────────┤
│ id (PK)  │ name      │ furColor    │
│ BIGINT   │ VARCHAR   │ VARCHAR     │
├──────────┼───────────┼─────────────┤
│ 2        │ Felix     │ Black       │
└──────────┴───────────┴─────────────┘

Nota: "name" está duplicado em ambas as tabelas!
```

---

## Participantes

- **Animal** (Classe Abstrata): Define interface comum e campos herdados, mas NÃO possui tabela correspondente no banco de dados.

- **Dog / Cat** (Classes Concretas): Possuem suas próprias tabelas independentes que incluem TODOS os campos (próprios + herdados).

- **Tabelas Concretas** (`dogs`, `cats`): Tabelas completamente independentes sem relacionamento de chave estrangeira entre elas.

- **Mapper/ORM**: Responsável por distribuir operações de save/load entre múltiplas tabelas desconexas ao trabalhar polimorficamente.

- **Sequence/ID Generator**: Deve gerar IDs globalmente únicos para evitar colisões entre tabelas diferentes (ex.: sequence compartilhada ou UUID).

---

## Colaborações

Ao salvar um Dog, o Mapper insere diretamente na tabela `dogs`, incluindo tanto os campos específicos (breed) quanto os herdados (name). É uma única operação INSERT, sem coordenação entre tabelas.

Ao carregar um Dog por ID, o Mapper executa SELECT diretamente na tabela `dogs`. Simples e rápido.

Para queries polimórficas ("todos os animais"), o Mapper deve executar UNION: `SELECT id, name, 'Dog' as type FROM dogs UNION SELECT id, name, 'Cat' as type FROM cats`. Isso é custoso e requer que o ORM conheça todas as subclasses concretas.

---

## Consequências

### Vantagens

1. **Máxima Performance de Leitura**: Cada query opera em uma única tabela, sem JOINs — velocidade máxima.
2. **Schema Simples por Tabela**: Cada tabela é independente e auto-contida, fácil de entender isoladamente.
3. **Sem Desperdício NULL**: Todas as colunas são sempre preenchidas — sem campos não utilizados.
4. **Restrições Completas**: Todos os campos podem ter NOT NULL, UNIQUE e outras restrições sem conflitos.
5. **Operações de Escrita Simples**: Save/Update/Delete operam em uma única tabela, sem coordenação.
6. **Isolamento de Subclasse**: Mudanças em uma subclasse não afetam os schemas de outras subclasses.

### Desvantagens

1. **Duplicação de Schema**: Colunas herdadas são duplicadas em múltiplas tabelas (DRY violado no nível do schema).
2. **Queries Polimórficas Complexas**: Buscar "todos os animais" requer UNIONs complexos de todas as tabelas concretas.
3. **Refatoração Perigosa**: Mover um campo de subclasse para superclasse requer ALTER TABLE em TODAS as tabelas concretas.
4. **Dificuldade de Manutenção**: Adicionar campo à superclasse abstrata requer atualizar o schema de todas as subclasses.
5. **Problemas de ID Global**: Garantir unicidade de ID entre tabelas desconexas requer coordenação (sequences compartilhadas ou UUIDs).

---

## Implementação

### Considerações de Implementação

1. **Geração de ID Único**: Usar uma única sequence compartilhada entre tabelas ou UUIDs para evitar colisões de ID entre tabelas.

2. **Conhecimento de Subclasses**: O ORM precisa conhecer todas as subclasses concretas para executar queries polimórficas (não pode descobrir dinamicamente).

3. **Evitar Queries Polimórficas**: Projetar a aplicação para minimizar a necessidade de buscar "todos os X da superclasse" — trabalhar com subclasses específicas.

4. **Migração Sincronizada**: Mudanças na superclasse requerem migrações coordenadas em todas as tabelas concretas simultaneamente.

5. **Views para Polimorfismo**: Criar views de banco de dados que façam UNION das tabelas para facilitar queries polimórficas ocasionais.

6. **Versionamento/Auditoria**: Implementar auditoria requer adicionar colunas de auditoria em cada tabela concreta separadamente.

### Técnicas de Implementação

1. **Mapeamento ORM**: Hibernate usa `@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)`. Entity Framework usa a estratégia TPC (Table-per-Concrete-class).

2. **UUID como PK**: Prefira UUIDs em vez de auto-increment para evitar a complexidade de sequence compartilhada.

3. **Geração de Código**: Usar geradores de código para propagar mudanças da superclasse para todas as tabelas concretas automaticamente.

4. **Carregamento Seletivo**: Configurar o ORM para não tentar carregamento polimórfico a menos que explicitamente solicitado.

5. **Discriminador Composto**: Em queries UNION, adicionar coluna sintética com o tipo para permitir ao ORM instanciar a classe correta.

6. **Funções de Banco de Dados**: Criar stored procedures que encapsulam UNIONs complexos para queries polimórficas frequentes.

---

## Usos Conhecidos

1. **Hibernate ORM**: Suporta via `TABLE_PER_CLASS`, mas a documentação adverte contra o uso devido à complexidade das queries polimórficas.

2. **Sistemas Legados**: Comum em sistemas que evoluíram organicamente onde cada "tipo" foi adicionado como tabela separada sem planejamento de herança.

3. **Data Warehouses**: Usam padrão similar onde dimensões de tipos diferentes (Customer, Supplier, Employee) são tabelas completamente separadas.

4. **Sistemas Multi-tenant**: Cada tenant pode ter sua própria tabela de subclasse, isolando completamente os dados.

5. **Sistemas de Relatório**: Onde agregações são sempre por tipo específico, nunca polimórficas.

6. **Rails (workaround)**: Embora o Rails prefira STI, algumas aplicações usam tabelas separadas com `type` manual para performance.

---

## Padrões Relacionados

- [**Single Table Inheritance**](010_single-table-inheritance.md): Alternativa que centraliza tudo em uma tabela com discriminador.
- [**Class Table Inheritance**](011_class-table-inheritance.md): Alternativa que normaliza com tabela por classe incluindo as abstratas.
- [**Inheritance Mappers**](013_inheritance-mappers.md): Ainda aplicável para organizar Mappers para cada classe concreta.
- [**Identity Field**](004_identity-field.md): Requer estratégia especial (UUID ou sequence global) para IDs únicos entre tabelas.
- [**Lazy Load**](003_lazy-load.md): Menos relevante, pois cada carregamento é de uma única tabela.
- [**Repository**](016_repository.md): Repository deve conhecer todas as subclasses concretas para queries polimórficas.
- [**Query Object**](015_query-object.md): Precisa construir UNIONs complexos para queries polimórficas.

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): classe concreta com foco definido
- [021 - Proibição de Duplicação de Lógica](../../clean-code/proibicao-duplicacao-logica.md): evitar duplicação de colunas

---

## Relação com Regras de Negócio

- **[022] Priorização de Simplicidade e Clareza**: Maximiza a simplicidade de queries individuais, mas complica as queries polimórficas.
- **[021] Proibição de Duplicação de Lógica**: Viola o DRY no schema ao duplicar colunas herdadas, mas aceito pelo ganho de performance.
- **[010] Single Responsibility Principle**: Cada tabela tem a única responsabilidade de armazenar dados de uma classe concreta.
- **[019] Stable Dependencies Principle**: Mudanças na superclasse instável propagam-se para todas as tabelas concretas.

---

**Criado em**: 2025-01-10
**Versão**: 1.0
