# Serialized LOB (Serialized Large Object)

**Tipo**: Padrão Object-Relational (Estrutural)

---

## Intenção e Objetivo

Salvar um grafo de objetos serializando-o em um único campo Large Object (LOB) do banco de dados, permitindo que estruturas complexas sejam persistidas sem decomposição em múltiplas tabelas.

## Também Conhecido Como

- Serialized Graph
- Blob Storage Pattern
- Object Serialization Mapping

---

## Motivação

Em sistemas orientados a objetos, frequentemente encontramos grafos de objetos complexos onde a decomposição em múltiplas tabelas relacionais seria excessivamente complexa ou desnecessária. Por exemplo, um objeto `PurchaseOrder` pode conter uma hierarquia de itens, descontos, calculadores de imposto e regras de negócio que mudam frequentemente. Mapear essa estrutura para um modelo relacional normalizado criaria dezenas de tabelas e joins complexos.

O padrão Serialized LOB resolve esse problema serializando todo o grafo de objetos em um formato binário ou textual (JSON, XML, Protocol Buffers) e armazenando-o em um único campo BLOB (Binary Large Object) ou CLOB (Character Large Object). Quando o objeto é necessário, o sistema desserializa o conteúdo do campo e reconstrói o grafo de objetos completo em memória.

A principal vantagem é a simplicidade do mapeamento: um objeto complexo é persistido com uma única operação de escrita e recuperado com uma única leitura. Isso elimina o impedance mismatch objeto-relacional para estruturas que não precisam ser consultadas por suas partes individuais. Porém, o custo é a perda da capacidade de query granular — não é possível escrever queries SQL que filtrem por atributos internos do objeto serializado sem carregar e desserializar todos os registros.

---

## Aplicabilidade

Use Serialized LOB quando:

- Você possui grafos de objetos complexos que mudam frequentemente e não justificam mapeamento relacional completo
- A estrutura interna do objeto não precisa ser consultada ou indexada pelo banco de dados
- O objeto é sempre carregado e salvo como uma unidade atômica (nunca parcialmente)
- A performance de serialização/desserialização é aceitável para o volume de dados
- Você precisa versionar ou auditar o estado completo de um objeto em um ponto no tempo
- A estrutura do objeto é altamente hierárquica ou baseada em grafo, tornando o mapeamento relacional complexo demais

---

## Estrutura

```
┌─────────────────────────────────────────────────────────────┐
│                        Código Cliente                        │
└────────────────────────────────┬────────────────────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   Domain Object         │
                    │  (ComplexOrder)         │
                    │ ─────────────────────   │
                    │ - items: List           │
                    │ - pricing: PriceCalc    │
                    │ - metadata: Map         │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   Serializer            │
                    │ ─────────────────────   │
                    │ + serialize(obj): bytes │
                    │ + deserialize(bytes)    │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   Campo LOB             │
                    │  (Coluna do Banco)      │
                    │ ─────────────────────   │
                    │  Tipo BLOB ou CLOB      │
                    └─────────────────────────┘

Tabela: orders
┌──────────┬─────────────┬──────────────────┐
│ order_id │ created_at  │ serialized_data  │
│ (PK)     │ TIMESTAMP   │ BLOB             │
├──────────┼─────────────┼──────────────────┤
│ 1001     │ 2025-01-15  │ <binary data...> │
│ 1002     │ 2025-01-16  │ <binary data...> │
└──────────┴─────────────┴──────────────────┘
```

---

## Participantes

- **Domain Object** (`ComplexOrder`): O objeto de domínio complexo que contém grafos aninhados de outros objetos. É agnóstico quanto à sua forma de persistência.

- **Serializer** (`ObjectSerializer`): Responsável por converter o grafo de objetos para um formato serializável (binário ou texto) e vice-versa. Pode usar bibliotecas como JSON, MessagePack, Protocol Buffers ou serialização nativa da linguagem.

- **Campo LOB** (Coluna `serialized_data`): Campo do banco de dados do tipo BLOB ou CLOB que armazena a representação serializada do objeto. Não possui estrutura interna consultável.

- **Data Mapper/Repository** (`OrderRepository`): Componente que coordena a persistência, invocando o Serializer para transformar objetos antes de salvar e após carregar do banco de dados.

- **Schema** (Tabela `orders`): Estrutura relacional minimalista contendo apenas o identificador, metadados básicos (timestamps, versão) e o campo LOB.

---

## Colaborações

Quando o cliente solicita o salvamento de um Domain Object complexo, o Data Mapper invoca o Serializer para transformar o grafo de objetos em uma sequência de bytes (ou string JSON). Essa representação serializada é então armazenada no campo LOB da tabela correspondente junto com metadados como ID e timestamp.

Durante a leitura, o processo é revertido: o Data Mapper recupera o conteúdo do campo LOB, passa ao Serializer que reconstrói o grafo de objetos original e retorna o Domain Object ao cliente. Toda a complexidade de persistência é encapsulada, e o cliente trabalha apenas com objetos de domínio ricos.

---

## Consequências

### Vantagens

1. **Simplicidade de Mapeamento**: Elimina a necessidade de criar dezenas de tabelas e relacionamentos para grafos complexos.
2. **Flexibilidade de Estrutura**: Mudanças na estrutura do objeto não requerem migrações complexas de esquema — apenas versionamento do formato.
3. **Performance de Carregamento**: Uma única operação de leitura carrega o objeto inteiro, sem necessidade de múltiplas queries ou joins.
4. **Atomicidade Natural**: O objeto é sempre salvo e carregado como uma unidade consistente, evitando estados parciais.
5. **Versionamento Facilitado**: Fácil manter snapshots completos do objeto para auditoria ou histórico.
6. **Complexidade ORM Reduzida**: Não requer configuração complexa de mapeamento objeto-relacional para estruturas hierárquicas.

### Desvantagens

1. **Perda da Capacidade de Query**: Não é possível escrever queries SQL que filtrem ou ordenem por atributos internos do objeto sem desserializar tudo.
2. **Impossibilidade de Indexação**: Campos internos do objeto não podem ter índices de banco de dados, prejudicando a performance de busca.
3. **Overhead de Serialização**: Operações de serialização/desserialização podem ser intensas em CPU para objetos muito grandes.
4. **Tamanho de Armazenamento**: Formatos de serialização podem ser menos eficientes que a decomposição relacional normalizada.
5. **Dificuldade de Migração de Dados**: Mudar a estrutura do objeto requer lógica de migração no código, não em SQL, e pode quebrar a desserialização de dados antigos.

---

## Implementação

### Considerações de Implementação

1. **Escolha do Formato de Serialização**: JSON oferece legibilidade e portabilidade; Protocol Buffers ou MessagePack oferecem compacidade e performance; serialização binária nativa oferece velocidade mas perde portabilidade entre linguagens.

2. **Versionamento do Schema**: Incluir um campo de versão no formato serializado para permitir migrações controladas quando a estrutura do objeto mudar.

3. **Tamanho Máximo do LOB**: Bancos de dados possuem limites para campos LOB (ex.: 16MB no MySQL padrão). Valide que seus objetos não excedem esses limites ou configure o banco adequadamente.

4. **Tratamento de Referências Circulares**: Muitos serializadores não lidam bem com grafos cíclicos. Use bibliotecas que suportam preservação de identidade de objetos ou refatore o modelo para evitar ciclos.

5. **Segurança na Desserialização**: A desserialização de dados não confiáveis pode ser um vetor de ataque (insecure deserialization). Valide e sanitize os dados antes de desserializar, especialmente se o formato for binário nativo.

6. **Compressão**: Para objetos grandes, considere compactar (gzip, zstd) os dados serializados antes de armazenar no LOB para economizar espaço e I/O.

### Técnicas de Implementação

1. **Serializer Abstrato**: Criar uma interface `Serializer<T>` com métodos `serialize(T obj): bytes` e `deserialize(bytes): T` para permitir trocar implementações.

2. **Metadados de Versionamento**: Incluir um campo `version` no início dos dados serializados (ex.: `{ version: 2, data: {...} }`) para suportar múltiplas versões do schema.

3. **Lazy Loading de LOBs**: Em alguns bancos, campos LOB são carregados lazily. Garanta que a conexão ainda está aberta ao acessar o LOB.

4. **Cache do Desserializado**: Manter o objeto desserializado em cache (Identity Map) para evitar desserialização repetida do mesmo registro.

5. **Auditoria via Snapshots**: Usar Serialized LOB para criar tabelas de auditoria onde cada mudança grava um snapshot completo do objeto serializado com timestamp.

6. **Queries Híbridas**: Manter campos importantes consultáveis fora do LOB (ex.: `order_id`, `customer_id`, `total_amount`) para permitir filtragem, e usar o LOB apenas para dados que não são consultados.

---

## Usos Conhecidos

1. **Hibernate ORM**: Suporta mapeamento de propriedades como `@Lob` para serializar objetos complexos em campos BLOB/CLOB.

2. **Sistemas de Event Sourcing**: Frameworks como Axon Framework armazenam eventos de domínio serializados (JSON ou Avro) em campos LOB de event stores.

3. **Salesforce**: A plataforma armazena metadados de customização de objetos como JSON serializado em campos LOB internos.

4. **Rails Active Record**: O método `serialize` permite armazenar hashes ou arrays Ruby complexos em campos TEXT usando YAML ou JSON.

5. **MongoDB (híbrido)**: Embora seja um banco NoSQL, o padrão é análogo — documentos BSON são "Serialized LOBs" que permitem estruturas aninhadas sem esquema fixo.

6. **Audit Trails em Sistemas Financeiros**: Bancos armazenam snapshots completos de transações como XML ou JSON em campos CLOB para conformidade regulatória.

---

## Padrões Relacionados

- [**Single Table Inheritance**](010_single-table-inheritance.md): Pode combinar com Serialized LOB para armazenar atributos específicos de subclasse em um campo LOB.
- [**Embedded Value**](008_embedded-value.md): Alternativa que decompõe o objeto em colunas da tabela pai, oposto da serialização completa.
- [**Data Transfer Object**](056_data-transfer-object.md): DTOs podem ser serializados em LOBs para comunicação entre camadas ou sistemas.
- [**GoF Memento**](../../gof/behavioral/006_memento.md): Serialized LOB é uma forma de implementar Memento para capturar e restaurar o estado do objeto.
- [**Repository**](016_repository.md): Repositories coordenam a serialização/desserialização de Domain Objects ao persistir em LOBs.
- [**Unit of Work**](001_unit-of-work.md): Gerencia quando serializar e persistir objetos modificados em LOBs.
- [**Metadata Mapping**](014_metadata-mapping.md): Pode usar metadados para controlar quais propriedades são serializadas no LOB.
- **Event Sourcing**: Eventos de domínio são frequentemente armazenados como Serialized LOBs em event stores.

### Relação com Rules

- [003 - Encapsulamento de Primitivos](../../object-calisthenics/003_encapsulamento-primitivos.md): Value Objects serializados
- [029 - Imutabilidade de Objetos](../../clean-code/imutabilidade-objetos-freeze.md): objetos serializados devem ser imutáveis

---

## Relação com Regras de Negócio

- **[003] Encapsulamento de Primitivos**: Objetos complexos serializados encapsulam toda sua lógica e dados, evitando a exposição de primitivos.
- **[029] Imutabilidade de Objetos**: Objetos serializados podem ser tratados como imutáveis — cada mudança cria uma nova versão serializada.
- **[010] Single Responsibility Principle**: O Serializer tem a única responsabilidade de transformação de formato, separada da lógica de domínio.
- **[045] Processos Stateless**: Serialized LOBs permitem que processos stateless persistam e recuperem o estado completo do objeto entre requisições.

---

**Criado em**: 2025-01-10
**Versão**: 1.0
