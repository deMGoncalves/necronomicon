# Foreign Key Mapping

**Classificação**: Padrão Object-Relational Estrutural

---

## Intenção e Objetivo

Mapear associação entre objetos para referência de chave estrangeira entre tabelas. Usa chave estrangeira no banco de dados para representar referências de objetos em memória.

## Também Conhecido Como

- FK Mapping
- Reference Mapping
- Association Mapping

## Motivação

Objetos referenciam outros objetos diretamente por meio de ponteiros ou referências. Bancos de dados relacionais representam relacionamentos por meio de chaves estrangeiras — colunas que armazenam o ID da linha relacionada. O Foreign Key Mapping traduz entre esses dois mundos.

Quando Order referencia Customer, em memória o Order possui referência direta ao objeto Customer. No banco de dados, a tabela orders tem a coluna customer_id contendo o ID do Customer. Ao salvar o Order, o Mapper extrai o ID do Customer e o armazena em customer_id. Ao carregar o Order, o Mapper usa customer_id para carregar o objeto Customer e estabelecer a referência.

Complexidades surgem com relacionamentos bidirecionais, lazy loading e cascatas. O Mapper precisa decidir quando carregar os objetos relacionados, como manter a consistência bidirecional e quais operações propagar (cascade save, delete, etc.).

## Aplicabilidade

Use Foreign Key Mapping quando:

- Objetos possuem relacionamentos um-para-um ou muitos-para-um
- Banco de dados relacional é usado para persistência
- Relacionamentos precisam ser navegáveis em memória
- Data Mapper ou Active Record é o padrão de persistência
- A integridade referencial precisa ser mantida
- O lazy loading de relacionamentos é desejável

## Estrutura

```
Domain Objects (em memória)
Order
├── id: 1
└── customer: → Customer{id:5, name:"João"}

Banco de Dados (persistido)
tabela orders
├── id: 1
├── customer_id: 5 (chave estrangeira)
└── total: 100.00

tabela customers
└── id: 5, name: "João"

Mapeamento:
Order.customer → orders.customer_id → Customer.id
```

## Participantes

- **Source Object**: Objeto que contém a referência (Order)
- **Target Object**: Objeto sendo referenciado (Customer)
- **Foreign Key Column**: Coluna no banco de dados que armazena o ID do alvo
- [**Data Mapper**](../data-source/004_data-mapper.md): Traduz entre referência e chave estrangeira
- [**Identity Field**](004_identity-field.md): ID usado para correlacionar objetos

## Colaborações

**Ao Salvar:**
- Mapper verifica o objeto Order a persistir
- Mapper encontra a referência Order.customer
- Mapper extrai customer.id (Identity Field)
- Mapper armazena customer.id em orders.customer_id
- Chave estrangeira no banco de dados aponta para a linha do customer

**Ao Carregar:**
- Mapper carrega linha da tabela orders
- Mapper encontra valor em customer_id
- Mapper usa customer_id para carregar Customer (via Identity Map ou query)
- Mapper estabelece referência Order.customer = customerObject
- Retorna Order com a referência preenchida

## Consequências

### Vantagens

- **Simplicidade**: Mapeamento direto e intuitivo
- **Integridade**: Restrições de chave estrangeira mantêm a integridade
- **Performance**: Índices em chaves estrangeiras otimizam joins
- **Navegação**: Relacionamentos navegáveis nos objetos
- **SQL padrão**: Usa recursos SQL padrão
- **Unidirecional**: Não requer relacionamento inverso

### Desvantagens

- **Queries N+1**: Carregar relacionamentos pode gerar muitas queries
- **Tratamento de nulo**: Chaves estrangeiras anuláveis complicam a lógica
- **Sincronização bidirecional**: Difícil manter consistência bidirecional
- **Complexidade de cascata**: Propagação de operações é complexa
- **Problemas com lazy load**: Requer sessão aberta para lazy loading
- **Acoplamento**: Tabela fonte acoplada ao alvo

## Implementação

### Considerações

1. **Estratégia de carregamento**: Eager vs. lazy loading do relacionamento
2. **Direcionalidade**: Unidirecional vs. bidirecional
3. **Nulabilidade**: A chave estrangeira pode ser nula?
4. **Operações em cascata**: Quais operações propagar (save, delete)
5. **Mapeamento inverso**: Como manter o relacionamento inverso consistente
6. **Performance**: Evitar o problema de query N+1

### Técnicas

- **Eager Loading**: Carregar relacionamento com join imediatamente
- **Lazy Loading**: Usar proxy para carregar relacionamento sob demanda
- **Batch Fetching**: Carregar múltiplos relacionamentos de uma vez
- **Cascade Save**: Salvar objetos relacionados automaticamente
- **Cascade Delete**: Excluir relacionados quando o pai é deletado
- **Orphan Removal**: Excluir objetos que não são mais referenciados

## Usos Conhecidos

- **Hibernate @ManyToOne**: Mapeamento muitos-para-um com chave estrangeira
- **Entity Framework Navigation Properties**: Relacionamentos via FK
- **ActiveRecord belongs_to**: Relacionamento de chave estrangeira
- **Sequelize belongsTo**: Associação com chave estrangeira
- **TypeORM @ManyToOne**: Coluna de chave estrangeira
- **SQLAlchemy ForeignKey**: Mapeamento de chave estrangeira

## Padrões Relacionados

- [**Identity Field**](004_identity-field.md): Fornece o ID para a chave estrangeira
- [**Association Table Mapping**](006_association-table-mapping.md): Para muitos-para-muitos
- [**Dependent Mapping**](007_dependent-mapping.md): Objetos dependentes sem FK
- [**Lazy Load**](003_lazy-load.md): Carrega relacionamentos sob demanda
- [**Data Mapper**](../data-source/004_data-mapper.md): Implementa o mapeamento
- [**Identity Map**](002_identity-map.md): Cache de objetos relacionados

### Relação com Rules

- [009 - Tell, Don't Ask](../../object-calisthenics/009_diga-nao-pergunte.md): relacionamentos navegáveis
- [034 - Lazy Load**](003_lazy-load.md): evita carregar tudo antecipadamente

---

**Criado em**: 2025-01-11
**Versão**: 1.0
