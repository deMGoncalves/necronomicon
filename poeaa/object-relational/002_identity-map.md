# Identity Map

**Classificação**: Padrão Object-Relational Comportamental

---

## Intenção e Objetivo

Garante que cada objeto seja carregado apenas uma vez, mantendo todo objeto carregado em um mapa. Consulta objetos usando o mapa para evitar duplicatas e assegurar que exista apenas uma instância de um objeto com determinado ID em memória.

## Também Conhecido Como

- Object Cache
- Session Cache
- First-Level Cache

## Motivação

Quando você carrega um objeto do banco de dados múltiplas vezes na mesma sessão, sem o Identity Map você terá várias cópias em memória. Isso causa problemas: mudanças em uma cópia não aparecem em outra, comparações de identidade falham e atualizações conflitantes podem corromper os dados.

O Identity Map resolve isso mantendo um mapa de objetos já carregados, indexados por ID. Quando o código solicita um objeto por ID, o Identity Map verifica primeiro o mapa. Se o objeto já estiver lá, retorna a referência existente. Se não, carrega do banco de dados, adiciona ao mapa e retorna. Isso garante que apenas uma instância do objeto com determinado ID exista na sessão.

Por exemplo, se você carregar Person(5) duas vezes, sem o Identity Map você teria duas instâncias diferentes. Com o Identity Map, ambas as requisições retornam a mesma instância. Mudanças feitas por uma referência são visíveis pela outra, pois é o mesmo objeto. Isso mantém a consistência e evita problemas sutis de estado.

## Aplicabilidade

Use Identity Map quando:

- Os mesmos objetos são acessados múltiplas vezes em uma sessão
- A identidade (referência) dos objetos precisa ser preservada
- Session ou Unit of Work estão sendo utilizados
- A performance de leituras repetidas precisa ser otimizada
- A consistência de estado dentro da sessão é crítica
- Múltiplas queries podem retornar os mesmos objetos

## Estrutura

```
Client
└── Usa: Repository ou Data Mapper

Repository/Data Mapper
└── Consulta: Identity Map

Identity Map
├── map: Map<ID, Object>
├── get(id): Object
│   └── Se existe: retorna do cache
│   └── Se não: carrega do BD, armazena no cache, retorna
├── add(id, object)
└── remove(id)

Fluxo:
1. Client solicita Person(5)
2. Mapper consulta IdentityMap.get(5)
3. Se Person(5) já estiver no mapa → retorna do cache
4. Se não → carrega do BD
5. Adiciona ao mapa via IdentityMap.add(5, person)
6. Retorna person
7. Próxima chamada para Person(5) → retorna do mapa
```

## Participantes

- [**Identity Map**](002_identity-map.md): Mapa que mantém os objetos carregados indexados por ID
- **Object Key**: ID ou chave composta usada para identificar o objeto
- **Cached Object**: Objeto armazenado no mapa
- **Data Mapper/Repository**: Usa o Identity Map para garantir a identidade
- **Session**: Escopo de vida do Identity Map (geralmente por sessão/requisição)

## Colaborações

- Client solicita objeto via Repository ou Data Mapper
- Mapper verifica o Identity Map primeiro usando o ID do objeto
- Se o objeto estiver no mapa, Mapper retorna a referência em cache
- Se o objeto não estiver no mapa, Mapper carrega do banco de dados
- Mapper adiciona o objeto recém-carregado ao Identity Map
- Mapper retorna o objeto ao Client
- Qualquer requisição subsequente pelo mesmo ID retorna a mesma instância
- Quando a sessão termina, o Identity Map é descartado

## Consequências

### Vantagens

- **Identidade garantida**: Apenas uma instância por ID na sessão
- **Performance**: Evita queries repetidas para os mesmos dados
- **Consistência**: Mudanças visíveis por todas as referências
- **Cache automático**: Cache de primeiro nível transparente
- **Simplicidade**: Client não precisa gerenciar cache manualmente
- **Previne bugs de aliasing**: Evita problemas de múltiplas cópias

### Desvantagens

- **Overhead de memória**: Mantém todos os objetos carregados em memória
- **Gerenciamento de ciclo de vida**: Precisa limpar o mapa quando a sessão termina
- **Concorrência**: Pode ocultar mudanças feitas por outras sessões
- **Complexidade**: Adiciona uma camada de gerenciamento de cache
- **Memory leaks**: Se não limpo corretamente, pode causar vazamentos
- **Dados desatualizados**: Dados em cache podem ficar desatualizados

## Implementação

### Considerações

1. **Escopo do mapa**: Geralmente por sessão/requisição; não global
2. **Tipo da chave**: ID simples ou chave composta (classe + ID)
3. **Limpeza**: Quando e como limpar o mapa
4. **Thread safety**: Se necessário para acesso concorrente
5. **Weak references**: Usar para permitir GC de objetos não utilizados
6. **Múltiplos mapas**: Um mapa por tipo de entidade vs. mapa único

### Técnicas

- **Mapa Simples**: Usar estrutura nativa Map/HashMap
- **Mapas por Tipo**: Mapa separado para cada tipo de entidade
- **Weak References**: Permitir coleta de lixo se memória for problema
- **Escopo de Sessão**: Associar o mapa à sessão ou Unit of Work
- **Estratégia de Chave**: Usar classe + ID como chave composta
- **Limpar ao Fechar**: Limpar o mapa quando a sessão for encerrada

## Usos Conhecidos

- **Hibernate Session**: Cache de primeiro nível é o Identity Map
- **Entity Framework Context**: Change tracker é o Identity Map
- **JPA EntityManager**: Contexto de persistência é o Identity Map
- **NHibernate Session**: Cache de sessão
- **SQLAlchemy Session**: Identity map embutido
- **TypeORM EntityManager**: Mantém identity map

## Padrões Relacionados

- [**Unit of Work**](001_unit-of-work.md): Trabalham juntos; UoW usa o Identity Map
- [**Data Mapper**](../data-source/004_data-mapper.md): Mapper consulta o Identity Map
- [**Repository**](016_repository.md): Repository usa o Identity Map internamente
- [**Lazy Load**](003_lazy-load.md): Identity Map pode conter proxies lazy
- [**GoF Flyweight**](../../gof/structural/006_flyweight.md): Similar; compartilha objetos
- **Second Level Cache**: Identity Map é o cache de primeiro nível

### Relação com Rules

- [029 - Imutabilidade de Objetos](../../clean-code/imutabilidade-objetos-freeze.md): Identity Map com imutáveis é thread-safe
- [045 - Processos Stateless](../../twelve-factor/006_processos-stateless.md): Identity Map é estado; escopo por requisição

---

**Criado em**: 2025-01-11
**Versão**: 1.0
