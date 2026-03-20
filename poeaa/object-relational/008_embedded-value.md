# Embedded Value

**Classificação**: Padrão Object-Relational Estrutural

---

## Intenção e Objetivo

Mapear um objeto para múltiplos campos na tabela que contém o objeto pai.

## Também Conhecido Como

- Aggregate Mapping
- Composite Value

## Motivação

Muitos objetos pequenos fazem sentido no código mas não justificam uma tabela própria. Um endereço com rua, cidade, estado e CEP é melhor como um objeto no código, mas criar uma tabela addresses separada seria over-engineering.

O Embedded Value resolve isso mapeando os campos do objeto de valor diretamente para colunas na tabela do objeto proprietário. O endereço do Customer fica em colunas CUSTOMER_STREET, CUSTOMER_CITY, etc., na tabela CUSTOMERS.

Este padrão mantém os benefícios de ter objetos ricos no código enquanto mantém o esquema do banco de dados simples e performático. É especialmente útil para Value Objects de DDD.

## Aplicabilidade

Use Embedded Value quando:

- O objeto de valor é sempre usado junto com seu proprietário
- O objeto é pequeno (2 a 6 campos)
- O objeto não é compartilhado entre múltiplos proprietários
- Performance: evitar joins desnecessários
- Value Objects em Domain-Driven Design
- Os dados são frequentemente acessados juntos

## Estrutura

```
Customer (no código)
├── id
├── name
└── address (objeto Address)
    ├── street
    ├── city
    ├── state
    └── zipCode

CUSTOMERS (no banco de dados)
├── ID
├── NAME
├── CUSTOMER_STREET
├── CUSTOMER_CITY
├── CUSTOMER_STATE
└── CUSTOMER_ZIP

Address está "embutido" nas colunas de Customer
```

## Participantes

- **Owner Object**: Objeto que contém o valor embutido
- [**Embedded Value**](008_embedded-value.md): Objeto mapeado para colunas do proprietário
- [**Mapper**](../base/002_mapper.md): Traduz entre o objeto aninhado e colunas planas
- **Database Table**: Tabela única com colunas para o proprietário e o embutido

## Colaborações

- Mapper carrega dados da tabela do proprietário
- Mapper cria tanto o objeto proprietário quanto o objeto de valor embutido
- Mapper injeta o valor embutido no proprietário
- Ao salvar, mapper extrai os dados do valor embutido e os persiste nas colunas do proprietário
- Não há tabela ou mapper separado para o valor embutido

## Consequências

### Vantagens

- **Performance**: Sem joins, query única
- **Simplicidade**: Sem tabelas adicionais
- **Atomicidade**: Proprietário e embutido sempre consistentes
- **Encapsulamento**: Objeto rico no código
- **Esquema simples**: Menos tabelas para gerenciar
- **Suporte a Value Object**: Perfeito para Value Objects de DDD

### Desvantagens

- **Duplicação**: Valor embutido duplicado se usado em múltiplos proprietários
- **Mudanças no esquema**: Alterar o embutido requer alterar múltiplas tabelas
- **Queries complexas**: Difícil realizar queries por campos embutidos
- **Tamanho da tabela**: Muitos valores embutidos aumentam o número de colunas
- **Tratamento de nulo**: Difícil distinguir embutido nulo de campos nulos

## Implementação

### Considerações

1. **Convenção de nomenclatura**: Prefixar colunas com o nome do proprietário ou do embutido
2. **Null object**: Como representar valor embutido ausente
3. **Múltiplos embutidos**: Múltiplos valores embutidos do mesmo tipo precisam de prefixos diferentes
4. **Imutabilidade do Value Object**: Valores embutidos devem ser imutáveis
5. **Reutilização**: Se o embutido for usado em múltiplos contextos, considerar tabela separada
6. **Explosão de colunas**: Limitar o número de valores embutidos por tabela

### Técnicas

- **Prefixar colunas**: CUSTOMER_STREET, CUSTOMER_CITY evita conflitos
- **Padrão Null Object**: Retornar Null Object quando todos os campos forem nulos
- **Factory methods**: Criar valor embutido a partir do ResultSet
- **Valores imutáveis**: Valores embutidos devem ser imutáveis
- **Agrupamento de colunas**: Agrupar colunas relacionadas logicamente

## Usos Conhecidos

- **Address**: Endereços embutidos em Customer, Order, etc.
- [**Money**](../base/007_money.md): Valores monetários (valor + moeda) embutidos
- **Date Range**: Período com data de início/fim embutido
- **Dimensions**: Altura, largura, profundidade em Product
- **Coordinates**: Latitude/longitude em Location
- **Name**: Nome/sobrenome em Person

## Padrões Relacionados

- [**Dependent Mapping**](007_dependent-mapping.md): Alternativa quando uma tabela separada é necessária
- [**Serialized LOB**](009_serialized-lob.md): Alternativa para objetos complexos
- [**Value Object**](../base/006_value-object.md): Conceito DDD para valores embutidos
- [**Foreign Key Mapping**](005_foreign-key-mapping.md): Quando compartilhado entre proprietários
- [**Data Mapper**](../data-source/004_data-mapper.md): Implementa o mapeamento

### Relação com Rules

- [003 - Encapsulamento de Primitivos](../../object-calisthenics/003_encapsulamento-primitivos.md): Value Objects
- [029 - Imutabilidade de Objetos](../../clean-code/imutabilidade-objetos-freeze.md): valores embutidos imutáveis

---

**Criado em**: 2025-01-11
**Versão**: 1.0
