# Lazy Load

**Classificação**: Padrão Object-Relational Comportamental

---

## Intenção e Objetivo

Um objeto que não contém todos os dados necessários, mas sabe como obtê-los quando precisar. Adia o carregamento dos dados até o momento em que eles são efetivamente acessados.

## Também Conhecido Como

- Lazy Initialization
- Deferred Loading
- On-Demand Loading
- Just-in-Time Loading

## Motivação

Carregar um objeto completo com todos os seus relacionamentos pode ser extremamente custoso. Um Customer pode ter centenas de Orders, cada Order com dezenas de Items. Carregar tudo de forma antecipada quando você só precisa do nome do Customer desperdiça memória e tempo.

O Lazy Load resolve isso carregando apenas os dados essenciais inicialmente, deixando os relacionamentos como "marcadores de posição" vazios. Quando o código acessa um relacionamento pela primeira vez, o lazy load detecta o acesso e carrega os dados do banco de dados naquele momento. Se o relacionamento nunca for acessado, ele nunca é carregado.

Existem quatro implementações principais: Lazy Initialization (verifica nulo e carrega), Virtual Proxy (objeto proxy que carrega na primeira chamada), Value Holder (wrapper que encapsula o carregamento) e Ghost (objeto parcialmente carregado que se preenche quando acessado). Cada uma tem compensações entre transparência e complexidade.

## Aplicabilidade

Use Lazy Load quando:

- Objetos possuem muitos relacionamentos raramente utilizados
- Carregar relacionamentos antecipadamente causa problemas de performance
- Os dados relacionados são grandes ou numerosos
- O problema de query N+1 é aceitável ou pode ser mitigado
- O acesso aos relacionamentos é previsível e controlado
- A transparência no carregamento não é crítica

## Estrutura

```
Client
└── Acessa: Domain Object

Domain Object
├── basicData: carregado antecipadamente
└── relationship: lazy (4 implementações)

1. Lazy Initialization
   └── getOrders() {
       if (orders == null) orders = loadOrders();
       return orders;
   }

2. Virtual Proxy
   └── orders: OrdersProxy
       └── Primeira chamada → carrega orders reais

3. Value Holder
   └── orders: ValueHolder<Orders>
       └── getValue() → carrega se necessário

4. Ghost
   └── Customer (parcialmente carregado)
       └── Qualquer acesso → carrega campos faltantes
```

## Participantes

- **Domain Object**: Objeto que possui dados lazy
- **Lazy Field**: Campo que será carregado sob demanda
- **Loader**: Responsável por carregar os dados quando necessário
- **Virtual Proxy**: Objeto proxy que intercepta o acesso
- **Value Holder**: Contêiner que encapsula o carregamento lazy
- **Ghost Object**: Objeto parcialmente inicializado
- [**Data Mapper**](../data-source/004_data-mapper.md): Carrega dados do banco de dados quando solicitado

## Colaborações

**Lazy Initialization:**
- Client acessa o método getter no Domain Object
- Getter verifica se o campo é nulo
- Se nulo, invoca o Data Mapper para carregar os dados
- Armazena os dados carregados e retorna
- Acessos subsequentes retornam os dados em cache

**Virtual Proxy:**
- Domain Object contém proxy em vez do objeto real
- Client acessa método no proxy
- Proxy intercepta a chamada e verifica se foi carregado
- Se não carregado, proxy carrega o objeto real
- Proxy delega a chamada ao objeto real

**Value Holder:**
- Domain Object contém ValueHolder
- Client chama getValue() no holder
- Holder verifica se foi carregado e carrega se necessário
- Retorna o valor

**Ghost:**
- Objeto carregado apenas com campos essenciais (ID, etc.)
- Primeiro acesso a campo não carregado dispara o carregamento
- Objeto carrega os campos faltantes e se "materializa"

## Consequências

### Vantagens

- **Performance inicial**: Objetos carregados mais rapidamente
- **Economia de memória**: Apenas dados necessários em memória
- **Redução de largura de banda**: Menos dados transferidos do banco de dados
- **Escalabilidade**: Suporta grafos de objetos grandes
- **Flexibilidade**: Client controla o que é carregado
- **Responsividade**: UI mais responsiva com menos espera

### Desvantagens

- **Problema de query N+1**: Pode gerar muitas queries pequenas
- **Transparência perdida**: Client pode precisar saber sobre o lazy load
- **Complexidade**: Adiciona complexidade ao modelo
- **Requisito de sessão**: Requer sessão ativa para carregar
- **Exceções inesperadas**: Pode lançar exceções em getters
- **Depuração difícil**: Difícil rastrear quando os carregamentos ocorrem

## Implementação

### Considerações

1. **Escolha da estratégia**: Lazy Init, Proxy, Value Holder ou Ghost
2. **Transparência**: Quanto o client deve saber sobre o lazy loading
3. **Gerenciamento de sessão**: Manter a sessão aberta para lazy loads
4. **Tratamento de exceção**: O que fazer quando o carregamento falha
5. **Estratégias de fetch**: Quando usar eager vs. lazy
6. **Carregamento em lote**: Carregar múltiplos objetos de uma vez

### Técnicas

- **Lazy Initialization**: Verificar nulo no getter e carregar
- **Virtual Proxy**: Criar proxy que carrega na primeira chamada
- **Value Holder**: Encapsular valor em objeto holder
- **Ghost**: Carregar objeto parcialmente e preencher depois
- **Batch Fetching**: Carregar múltiplos objetos relacionados juntos
- **Subselect Fetching**: Usar subselect para carregar relacionados
- **Extra Lazy**: Operações em coleções sem carregar tudo

## Usos Conhecidos

- **Hibernate**: Lazy loading de relacionamentos e coleções
- **Entity Framework**: Lazy loading via proxies dinâmicos
- **JPA**: Fetch type lazy padrão para coleções
- **NHibernate**: Geração de proxies lazy
- **ActiveRecord (Rails)**: Queries e associações lazy
- **Doctrine (PHP)**: Lazy loading com proxies

## Padrões Relacionados

- [**GoF Proxy**](../../gof/structural/007_proxy.md): Virtual Proxy é implementação de Lazy Load
- [**Identity Map**](002_identity-map.md): Trabalha em conjunto; Identity Map pode conter proxies
- [**Data Mapper**](../data-source/004_data-mapper.md): Mapper carrega dados lazily
- [**Unit of Work**](001_unit-of-work.md): Sessão precisa estar aberta para o lazy load
- [**Repository**](016_repository.md): Repository configura o lazy loading
- [**GoF Strategy**](../../gof/behavioral/009_strategy.md): Diferentes estratégias de carregamento

### Relação com Rules

- [036 - Restrição de Funções com Efeitos Colaterais](../../clean-code/restricao-funcoes-efeitos-colaterais.md): getter com lazy load possui efeito colateral
- [027 - Qualidade no Tratamento de Erros](../../clean-code/qualidade-tratamento-erros-dominio.md): lazy load pode lançar exceções

---

**Criado em**: 2025-01-11
**Versão**: 1.0
