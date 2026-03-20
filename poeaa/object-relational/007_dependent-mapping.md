# Dependent Mapping

**Classificação**: Padrão Object-Relational Estrutural

---

## Intenção e Objetivo

Mapear objetos dependentes que não possuem identidade própria e existem apenas no contexto de seu objeto pai.

## Também Conhecido Como

- Cascading Mapper
- Child Mapping

## Motivação

Objetos dependentes são aqueles que não fazem sentido fora de seu proprietário. Por exemplo, Order Items não fazem sentido sem um Order. Eles não possuem identidade independente e seu ciclo de vida está acoplado ao objeto pai.

O Dependent Mapping lida com isso tornando o mapper do objeto pai responsável por também mapear seus dependentes. Quando você carrega um Order, automaticamente carrega seus Order Items. Quando você salva um Order, também salva todos os itens.

Este padrão simplifica o mapeamento eliminando a necessidade de mappers separados para objetos dependentes, centralizando toda a lógica de persistência no mapper da raiz do agregado. É especialmente útil em Domain-Driven Design (DDD) para reforçar as fronteiras do agregado.

## Aplicabilidade

Use Dependent Mapping quando:

- Objetos dependentes não possuem identidade fora do pai
- O ciclo de vida do dependente está vinculado ao do pai
- Dependentes são sempre carregados/salvos com o pai
- Não há acesso direto aos dependentes sem o pai
- Fronteiras de agregados em Domain-Driven Design
- Performance: você sempre precisa dos dependentes junto com o pai

## Estrutura

```
Order (Aggregate Root)
├── OrderItem (Dependent)
├── OrderItem (Dependent)
└── OrderItem (Dependent)

OrderMapper
├── load(id) → carrega Order + todos os OrderItems
├── save(Order) → salva Order + todos os OrderItems
└── delete(id) → exclui Order + todos os OrderItems

OrderItemMapper não existe
(OrderItems são mapeados via OrderMapper)
```

## Participantes

- **Aggregate Root**: Objeto pai com identidade independente
- **Dependent Object**: Objeto que existe apenas no contexto do pai
- **Owner Mapper**: Mapper da raiz do agregado que também mapeia os dependentes
- **Database**: Tabelas relacionadas por chave estrangeira

## Colaborações

- Client solicita ao Owner Mapper que carregue a raiz do agregado
- Owner Mapper carrega os dados do pai da tabela principal
- Owner Mapper carrega automaticamente os dados dependentes das tabelas relacionadas
- Owner Mapper constrói o grafo de objetos completo (pai + dependentes)
- Ao salvar, Owner Mapper persiste pai e dependentes em cascata

## Consequências

### Vantagens

- **Simplicidade**: Mapper único para o agregado completo
- **Consistência**: Pai e dependentes sempre sincronizados
- **Performance**: Carregamento em lote eficiente
- **Fronteira do agregado**: Reforça as fronteiras de agregados DDD
- **Manutenibilidade**: Lógica de persistência centralizada
- **Atomicidade**: Operações do pai e dependentes são atômicas

### Desvantagens

- **Carregamento desnecessário**: Sempre carrega dependentes mesmo que não sejam necessários
- **Complexidade do mapper**: O mapper do pai torna-se mais complexo
- **Flexibilidade limitada**: Não é possível acessar dependentes de forma independente
- **Acoplamento**: Dependentes fortemente acoplados ao ciclo de vida do pai
- **Difícil de refatorar**: Se o dependente precisar se tornar independente no futuro

## Implementação

### Considerações

1. **Identificar dependentes**: Objetos sem identidade ou ciclo de vida independente
2. **Operações em cascata**: Implementar cascata de save/delete no mapper do pai
3. **Estratégia de carregamento**: Usar joins ou queries separadas para carregar dependentes
4. **Tratamento de coleções**: Mapear coleções de dependentes corretamente
5. **Excluir órfãos**: Remover dependentes que não existem mais na coleção
6. **Versionamento**: Incluir dependentes no cálculo da versão do agregado

### Técnicas

- **Join fetching**: Carregar pai e dependentes em uma única query com JOIN
- **Batch loading**: Carregar dependentes em query separada após carregar os pais
- **Algoritmo diff**: Comparar coleções antigas e novas para determinar o que inserir/atualizar/excluir
- **Marcar para exclusão**: Marcar dependentes órfãos para exclusão
- **Integração com Unit of Work**: Integrar com Unit of Work para gerenciar operações em cascata
- **Regras de cascata**: Definir regras claras de cascata (save, delete, update)

## Usos Conhecidos

- **Order/OrderItem**: Pedidos e itens de pedido em e-commerce
- **Invoice/InvoiceItem**: Faturas e linhas de fatura
- **Document/Paragraph**: Documentos e parágrafos
- **Album/Photo**: Álbuns de fotos e fotos individuais quando a foto só existe no álbum
- **Playlist/Song**: Playlists e músicas quando a música só existe na playlist
- **Form/Field**: Formulários e campos de formulário dinâmicos

## Padrões Relacionados

- [**Embedded Value**](008_embedded-value.md): Alternativa quando o dependente cabe na tabela do pai
- [**Identity Map**](002_identity-map.md): Não aplicável a dependentes (sem identidade)
- [**Unit of Work**](001_unit-of-work.md): Coordena operações em cascata
- [**Data Mapper**](../data-source/004_data-mapper.md): Padrão base para mapeamento
- [**Foreign Key Mapping**](005_foreign-key-mapping.md): Implementa o relacionamento no banco de dados
- [**Lazy Load**](003_lazy-load.md): Alternativa para evitar carregar dependentes sempre
- [**GoF Composite**](../../gof/structural/003_composite.md): Estrutura de agregado com dependentes

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): mapper responsável pelo agregado
- [029 - Imutabilidade de Objetos](../../clean-code/imutabilidade-objetos-freeze.md): considerar imutabilidade dos dependentes

---

**Criado em**: 2025-01-11
**Versão**: 1.0
