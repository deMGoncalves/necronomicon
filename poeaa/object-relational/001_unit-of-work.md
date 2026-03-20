# Unit of Work

**Classificação**: Padrão Object-Relational Comportamental

---

## Intenção e Objetivo

Mantém uma lista de objetos afetados por uma transação de negócio e coordena a escrita das mudanças e a resolução de problemas de concorrência. Rastreia todas as alterações durante uma sessão e as persiste de uma vez só.

## Também Conhecido Como

- Transaction Manager
- Change Tracker
- Session

## Motivação

Ao trabalhar com objetos em memória que precisam ser persistidos, rastrear quais objetos foram alterados, criados ou excluídos é complexo. Sem controle centralizado, você pode esquecer de salvar mudanças, salvar o mesmo objeto múltiplas vezes, ou executar operações na ordem errada, causando violações de integridade.

O Unit of Work resolve isso mantendo uma lista de todos os objetos carregados e rastreando suas alterações. Quando você modifica um objeto, o Unit of Work registra a mudança. Quando você cria um novo objeto, o Unit of Work o registra como "novo". Quando você exclui, o Unit of Work registra como "removido". No commit, o Unit of Work calcula a ordem correta das operações e executa todas as mudanças em uma única transação de banco de dados.

Por exemplo, em uma transação de pedido você pode criar um Order, adicionar OrderItems, atualizar o estoque de Product e atualizar o crédito do Customer. O Unit of Work rastreia tudo. No commit, ele executa INSERTs para Order e Items, UPDATEs para Products e Customer, tudo na ordem correta e em uma única transação. Se algo falhar, tudo é revertido automaticamente.

## Aplicabilidade

Use Unit of Work quando:

- Múltiplos objetos são modificados em uma transação de negócio
- As mudanças precisam ser confirmadas atomicamente
- A otimização de queries de atualização é importante (batch updates)
- A ordem das operações de banco de dados precisa ser gerenciada
- O Domain Model é utilizado (frequentemente com Data Mapper)
- Problemas de concorrência precisam ser detectados e resolvidos

## Estrutura

```
Client (Service Layer)
└── Usa: Unit of Work

Unit of Work
├── Registros de Objetos:
│   ├── newObjects: List<Object>
│   ├── dirtyObjects: List<Object>
│   ├── removedObjects: List<Object>
│   └── clean: List<Object>
├── Métodos Públicos:
│   ├── registerNew(object)
│   ├── registerDirty(object)
│   ├── registerRemoved(object)
│   ├── registerClean(object)
│   └── commit()
└── Colabora com:
    ├── Data Mappers (para persistir)
    └── Identity Map (para carregar)

Fluxo:
1. Client carrega objetos
2. Client modifica objetos → UoW registra como dirty
3. Client cria objetos → UoW registra como new
4. Client exclui objetos → UoW registra como removed
5. Client chama commit()
6. UoW ordena as operações
7. UoW inicia transação de banco de dados
8. UoW executa INSERTs (objetos novos)
9. UoW executa UPDATEs (objetos dirty)
10. UoW executa DELETEs (objetos removidos)
11. UoW confirma a transação
```

## Participantes

- **Unit of Work**: Rastreia mudanças e coordena a persistência
- **Domain Objects**: Objetos sendo modificados durante a transação
- **Data Mappers**: Executam SQL para persistir as mudanças
- [**Identity Map**](002_identity-map.md): Mantém os objetos carregados únicos
- **Listas de Objetos**: Listas de objetos novos, sujos, removidos e limpos
- **Transaction**: Transação de banco de dados gerenciada

## Colaborações

- Client carrega objetos via Repository ou Data Mapper
- Objetos carregados são registrados como "clean" no Unit of Work
- Client modifica objetos; objetos se auto-registram como "dirty" ou o Client registra explicitamente
- Client cria novos objetos e os registra como "new"
- Client marca objetos para exclusão registrando-os como "removed"
- Client chama commit() no Unit of Work
- Unit of Work calcula a ordem das operações com base nas dependências
- Unit of Work inicia a transação de banco de dados
- Unit of Work itera sobre objetos "new" e chama Mapper.insert()
- Unit of Work itera sobre objetos "dirty" e chama Mapper.update()
- Unit of Work itera sobre objetos "removed" e chama Mapper.delete()
- Se tudo ocorrer bem, Unit of Work confirma a transação
- Se ocorrer erro, Unit of Work realiza rollback da transação

## Consequências

### Vantagens

- **Atomicidade**: Todas as mudanças são confirmadas ou nenhuma é
- **Performance**: Batch updates reduzem idas e vindas ao banco de dados
- **Consistência**: Ordem correta das operações garantida
- **Simplicidade para o client**: Client não gerencia transações manualmente
- **Detecção de concorrência**: Pode detectar conflitos antes de confirmar
- **Otimização**: Pode eliminar atualizações redundantes

### Desvantagens

- **Complexidade**: Implementação complexa; difícil de fazer corretamente
- **Overhead de memória**: Mantém referências a todos os objetos modificados
- **Estado oculto**: O estado da transação pode não ser óbvio
- **Momento do commit**: Difícil saber quando confirmar para melhor performance
- **Cascatas**: Difícil gerenciar operações em cascata
- **Depuração**: Problemas aparecem apenas no commit, longe de onde o erro foi introduzido

## Implementação

### Considerações

1. **Registro de objetos**: Decidir se os objetos se auto-registram ou se o client registra explicitamente
2. **Detecção de mudanças**: Snapshot original vs dirty tracking vs proxy
3. **Ordenação**: Calcular a ordem correta com base nas dependências
4. **Identidade**: Integrar com o Identity Map para evitar duplicatas
5. **Concorrência**: Implementar bloqueio otimista ou pessimista
6. **Escopo**: Definir o tempo de vida do Unit of Work (por requisição, etc.)

### Técnicas

- **Registro de Objetos**: Métodos register* para rastrear objetos
- **Registro pelo Chamador**: Client registra objetos explicitamente
- **Auto-Registro pelo Objeto**: Objetos se registram ao serem modificados
- **Change Tracking**: Comparar snapshots para detectar mudanças
- **Ordenação Topológica**: Ordenar operações com base nas dependências
- **Gerenciamento de Transação**: Iniciar/confirmar/reverter transações
- **Operações em Lote**: Agrupar operações similares

## Usos Conhecidos

- **Hibernate Session**: Padrão Unit of Work do Hibernate
- **Entity Framework DbContext**: EF usa Unit of Work
- **JPA EntityManager**: JPA EntityManager é Unit of Work
- **NHibernate Session**: Implementação do NHibernate
- **SQLAlchemy Session**: Session do ORM Python
- **TypeORM EntityManager**: ORM TypeScript

## Padrões Relacionados

- [**Data Mapper**](../data-source/004_data-mapper.md): Unit of Work coordena os Mappers
- [**Identity Map**](002_identity-map.md): Trabalha em conjunto para garantir a identidade
- [**Repository**](016_repository.md): Repository usa Unit of Work internamente
- [**Lazy Load**](003_lazy-load.md): Unit of Work pode disparar lazy loads
- [**Optimistic Offline Lock**](057_optimistic-offline-lock.md): Detecta conflitos
- [**Service Layer**](../domain-logic/004_service-layer.md): Service Layer gerencia o Unit of Work

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): UoW responsável pelas transações
- [027 - Qualidade no Tratamento de Erros](../../clean-code/qualidade-tratamento-erros-dominio.md): rollback automático
- [028 - Tratamento de Exceção Assíncrona](../../clean-code/tratamento-excecao-assincrona.md): gerencia transações assíncronas

---

**Criado em**: 2025-01-11
**Versão**: 1.0
