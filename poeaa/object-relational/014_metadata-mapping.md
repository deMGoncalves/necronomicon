# Metadata Mapping

**Tipo**: Padrão Object-Relational (Metadados)

---

## Intenção e Objetivo

Manter os detalhes de como os objetos de domínio se mapeiam para estruturas de banco de dados em arquivos de metadados (XML, anotações, JSON) separados do código principal, permitindo que o framework de persistência configure o mapeamento dinamicamente.

## Também Conhecido Como

- External Mapping
- Configuration-Based Mapping
- Declarative Mapping

---

## Motivação

Codificar o mapeamento objeto-relacional diretamente no código (hardcoding de queries SQL, construção manual de objetos a partir de ResultSets) é trabalhoso, repetitivo e propenso a erros. Cada classe de domínio requer código de mapeamento substancial que lida com transformações de tipo, nomenclatura de colunas, relacionamentos, herança, etc. Esse código de infraestrutura polui as classes de domínio e torna as mudanças difíceis.

O Metadata Mapping resolve esse problema externalizando as regras de mapeamento para arquivos de metadados declarativos. Em vez de escrever código que diz "a propriedade `fullName` mapeia para a coluna `full_name` do tipo VARCHAR", você escreve uma declaração: `<property name="fullName" column="full_name" type="string"/>`. Um framework de persistência (ORM) lê esses metadados em tempo de execução e gera automaticamente o código de mapeamento necessário.

A vantagem é a separação de responsabilidades: o código de domínio permanece limpo e focado na lógica de negócio, enquanto os detalhes técnicos de persistência ficam na configuração. Mudanças de mapeamento (ex.: renomear uma coluna) não requerem recompilação do código. Diferentes estratégias de mapeamento podem ser aplicadas sem tocar no domínio. O custo é a complexidade de aprender e manter os arquivos de metadados, e a possível perda de type-safety (erros detectados apenas em tempo de execução).

---

## Aplicabilidade

Use Metadata Mapping quando:

- Você possui múltiplas classes de domínio que precisam ser persistidas e quer evitar código de mapeamento repetitivo
- O mapeamento objeto-relacional é complexo (herança, relacionamentos, tipos customizados) e se beneficiaria de abstração
- Você quer manter o código de domínio limpo e independente de detalhes de persistência
- Desenvolvedores diferentes podem trabalhar no schema do banco de dados e no código de domínio de forma independente
- Você precisa suportar múltiplos bancos de dados ou mudar estratégias de mapeamento sem alterar o código
- Um framework ORM maduro (Hibernate, Entity Framework, Doctrine) está disponível para interpretar os metadados

---

## Estrutura

```
┌──────────────────────────────────────────────────────────────┐
│                    Código da Aplicação                        │
└────────────────────────────┬─────────────────────────────────┘
                             │ usa
                ┌────────────▼────────────┐
                │  Domain Object          │
                │  (User)                 │
                │ ─────────────────────   │
                │ - id: Long              │
                │ - fullName: String      │
                │ - email: String         │
                └─────────────────────────┘
                      △
                      │ mapeia
    ┌─────────────────┴──────────────────────────────┐
    │         Configuração de Metadados              │
    │  ────────────────────────────────────────────  │
    │  <class name="User" table="users">             │
    │    <id name="id" column="user_id"/>            │
    │    <property name="fullName"                   │
    │              column="full_name"                │
    │              type="string"/>                   │
    │    <property name="email"                      │
    │              column="email_address"            │
    │              type="string"/>                   │
    │  </class>                                      │
    └────────────────────┬───────────────────────────┘
                         │ lido por
            ┌────────────▼────────────┐
            │  Framework ORM          │
            │ ─────────────────────   │
            │ + configure(metadata)   │
            │ + save(object)          │
            │ + find(id)              │
            └────────────┬────────────┘
                         │ gera
            ┌────────────▼────────────┐
            │  Instruções SQL         │
            │ ─────────────────────   │
            │  INSERT INTO users...   │
            │  SELECT * FROM users... │
            └─────────────────────────┘

Alternativas: XML, Anotações, JSON, YAML, Fluent API
```

---

## Participantes

- **Domain Object** (`User`): Classe de domínio POJO (Plain Old Java Object) que não contém lógica de persistência. É agnóstica sobre como é mapeada.

- **Configuração de Metadados** (XML/Anotações): Arquivo ou anotações que declaram como as propriedades do objeto mapeiam para as colunas do banco de dados, tipos de dados, relacionamentos, estratégias de carregamento, etc.

- **Framework ORM** (Hibernate, Entity Framework): Motor que lê os metadados na inicialização ou em tempo de execução, constrói um modelo de mapeamento interno e usa esse modelo para gerar SQL e transformar dados.

- **Leitor de Metadados de Mapeamento**: Componente do ORM responsável por analisar arquivos XML, refletir anotações ou processar configurações programáticas.

- **Gerador SQL**: Componente que usa os metadados de mapeamento para gerar dinamicamente instruções SQL (SELECT, INSERT, UPDATE, DELETE) adequadas ao schema.

---

## Colaborações

Durante a inicialização da aplicação, o Framework ORM escaneia pacotes ou arquivos de configuração, encontra os metadados de mapeamento (arquivos XML ou anotações) e os analisa para construir um metamodelo interno que descreve como cada classe mapeia para tabelas e colunas.

Quando a aplicação solicita `repository.save(user)`, o ORM consulta o metamodelo para descobrir que User mapeia para a tabela `users`, que `fullName` vai para a coluna `full_name`, etc. Ele então constrói dinamicamente o SQL INSERT apropriado, o executa e retorna o objeto persistido com o ID gerado.

---

## Consequências

### Vantagens

1. **Separação de Responsabilidades**: O código de domínio está limpo e livre de detalhes de persistência SQL/ORM.
2. **DRY**: Elimina código de mapeamento manual repetitivo (construção de objetos a partir de ResultSet, preenchimento de PreparedStatements).
3. **Flexibilidade**: Mudanças de schema (renomear colunas, mudar tipos) podem ser feitas alterando apenas os metadados, não o código.
4. **Portabilidade de Banco de Dados**: O ORM pode adaptar o SQL para diferentes dialetos de banco de dados com base nos metadados.
5. **Produtividade**: Desenvolvimento mais rápido — foco na lógica de negócio, não no plumbing de persistência.
6. **Estratégias Declarativas**: Cache, lazy loading, cascatas, herança — tudo configurável via metadados.

### Desvantagens

1. **Perda de Type-Safety**: Erros de mapeamento (nome de coluna errado, tipo incompatível) são detectados apenas em tempo de execução, não em tempo de compilação.
2. **Complexidade de Aprendizado**: Desenvolvedores precisam aprender a DSL do ORM (schema XML, anotações) além da linguagem.
3. **Depuração Difícil**: Problemas de mapeamento geram stack traces profundos e crípticos do ORM, não do código de negócio.
4. **Overhead de Performance**: Reflection e geração dinâmica de SQL têm custo computacional comparado ao SQL artesanal.
5. **Vendor Lock-in**: Os metadados geralmente são específicos do ORM (Hibernate vs EF), tornando a migração difícil.

---

## Implementação

### Considerações de Implementação

1. **Escolha do Formato**: XML é verboso mas validável com XSD; anotações são concisas mas poluem o código; Fluent API é type-safe mas requer mais código. Escolha com base nas preferências da equipe.

2. **Cache do Metamodelo**: A análise de metadados é custosa. Os ORMs devem fazer cache do metamodelo e revalidar apenas quando os arquivos de configuração mudam.

3. **Validação de Metadados**: Implementar validação rigorosa de metadados na inicialização para detectar erros (colunas inexistentes, tipos incompatíveis) antes do tempo de execução.

4. **Convention over Configuration**: Minimizar metadados usando convenções (ex.: propriedade `name` → coluna `name`). Configurar apenas as exceções.

5. **Ambiente Multi-tenant**: Os metadados podem precisar variar por tenant. Considerar metamodelos separados ou resolução dinâmica.

6. **Versionamento de Schema**: Incluir versão nos metadados para suportar migrações e evolução controlada do schema.

### Técnicas de Implementação

1. **Mapeamento Baseado em Anotações**: Usar anotações (@Entity, @Column, @OneToMany) diretamente nas classes de domínio para configuração inline.

2. **Mapeamento XML Externo**: Manter arquivos .hbm.xml (Hibernate) ou .edmx (Entity Framework) separados para completa separação de código e configuração.

3. **Configuração Fluent**: Usar APIs fluentes (ex.: Entity Framework Fluent API) para configurar o mapeamento no código com type-safety.

4. **Mapeamento Baseado em Convenções**: Implementar convenções padrão (tabela = plural da classe, PK = Id) e sobrescrever apenas quando necessário.

5. **Configurações Compostas**: Combinar abordagens — usar anotações para casos simples, XML para casos complexos (herança, queries customizadas).

6. **Geração de Código**: Gerar classes de domínio a partir de metadados (abordagem database-first) ou gerar metadados a partir das classes (abordagem code-first).

---

## Usos Conhecidos

1. **Hibernate (Java)**: O ORM original que popularizou o metadata mapping via arquivos .hbm.xml (versões antigas) e anotações JPA (versões modernas).

2. **Entity Framework (.NET)**: Suporta três abordagens: Database First (gera classes a partir do schema), Code First (gera schema a partir das classes) e Model First (designer visual gera ambos).

3. **Doctrine (PHP)**: Usa anotações (@ORM\Entity, @ORM\Column) ou YAML/XML para mapeamento de metadados de entidades.

4. **SQLAlchemy (Python)**: Suporta mapeamento declarativo via classes Python com metadados embutidos ou mapeamento clássico via separação total.

5. **ActiveRecord (Ruby on Rails)**: Usa convention over configuration — o mapeamento é implícito com base nos nomes de classe e tabela, com sobrescritas declarativas.

6. **MyBatis (Java)**: Usa arquivos XML para mapear instruções SQL a métodos de interface, dando controle total sobre SQL enquanto mantém os metadados separados.

---

## Padrões Relacionados

- [**Data Mapper**](../data-source/004_data-mapper.md): Metadata Mapping configura como os Data Mappers realizam as transformações objeto-relacionais.
- [**Repository**](016_repository.md): Repositories dependem do metadata mapping para abstrair a persistência dos objetos de domínio.
- [**Unit of Work**](001_unit-of-work.md): Coordena com o metadata mapping para rastrear mudanças de objetos e gerar SQL de persistência.
- [**Identity Map**](002_identity-map.md): Usa os metadados do Identity Field para fazer cache de objetos pela chave primária.
- [**Lazy Load**](003_lazy-load.md): Configurado via metadados (ex.: `fetch="lazy"` em XML ou `lazy: true` em anotações).
- [**Query Object**](015_query-object.md): Usa o metamodelo para construir queries type-safe com base na estrutura do objeto.
- [**Inheritance Mappers**](013_inheritance-mappers.md): Os metadados declaram a estratégia de mapeamento de herança (Single/Class/Concrete Table).

### Relação com Rules

- [021 - Proibição de Duplicação de Lógica](../../clean-code/proibicao-duplicacao-logica.md): metadados eliminam duplicação
- [022 - Priorização de Simplicidade e Clareza](../../clean-code/priorizacao-simplicidade-clareza.md): configuração declarativa

---

## Relação com Regras de Negócio

- **[010] Single Responsibility Principle**: Os metadados separam a responsabilidade de persistência da lógica de domínio.
- **[014] Dependency Inversion Principle**: Classes de domínio não dependem de detalhes de persistência — os metadados invertem a dependência.
- **[022] Priorização de Simplicidade e Clareza**: Metadados declarativos podem ser mais claros do que código de mapeamento imperativo.
- **[021] Proibição de Duplicação de Lógica**: Elimina a duplicação de código de mapeamento manual por meio de geração automática baseada em metadados.

---

**Criado em**: 2025-01-10
**Versão**: 1.0
