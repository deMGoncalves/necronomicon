# Flyweight

**Classificação**: Padrão Estrutural

---

## Intenção e Objetivo

Usar compartilhamento para suportar grandes quantidades de objetos refinados de forma eficiente. Reduz os custos de memória por meio do compartilhamento de porções de estado comum entre múltiplos objetos, em vez de manter todos os dados em cada objeto.

## Também Conhecido Como

- Flyweight
- Object Cache

## Motivação

Algumas aplicações poderiam se beneficiar do uso de objetos em todo o seu design, mas uma implementação ingênua seria proibitivamente cara. Um editor de documentos pode usar objetos para representar cada caractere, permitindo formatação e layout refinados. Mas isso poderia criar centenas de milhares de objetos, consumindo memória excessiva.

O Flyweight resolve isso por meio do compartilhamento de objetos. O caractere 'a' pode ser representado por um único objeto compartilhado. Cada ocorrência do caractere no documento referencia o mesmo objeto flyweight. O estado intrínseco (código do glifo, fonte) é armazenado no flyweight; o estado extrínseco (posição, estilo específico) é mantido pelo cliente.

## Aplicabilidade

Use o padrão Flyweight quando TODAS as seguintes condições forem verdadeiras:

- A aplicação usa grande número de objetos
- Os custos de armazenamento são altos devido à quantidade de objetos
- A maior parte do estado do objeto pode ser tornada extrínseca
- Muitos grupos de objetos podem ser substituídos por relativamente poucos objetos compartilhados após a remoção do estado extrínseco
- A aplicação não depende da identidade do objeto (objetos flyweight são compartilhados e não distinguíveis)

## Estrutura

```
Client
├── Maintains: extrinsic state
└── Uses: FlyweightFactory
    └── getFlyweight(key) → returns shared Flyweight

FlyweightFactory
├── Maintains: pool Map<key, Flyweight>
└── getFlyweight(key)
    ├── If flyweight exists in pool
    │   └── Return existing
    └── Else
        ├── Create new Flyweight
        ├── Add to pool
        └── Return new

Flyweight (Interface)
└── operation(extrinsicState)

ConcreteFlyweight implements Flyweight
├── Maintains: intrinsic state (shared)
└── operation(extrinsicState)
    └── Uses intrinsic + extrinsic state
```

## Participantes

- [**Flyweight**](006_flyweight.md): Declara a interface por meio da qual os flyweights podem receber e agir sobre o estado extrínseco
- **ConcreteFlyweight**: Implementa a interface Flyweight e adiciona armazenamento para estado intrínseco; deve ser compartilhável; o estado deve ser intrínseco
- **UnsharedConcreteFlyweight**: Nem todos os objetos Flyweight precisam ser compartilhados; a interface Flyweight habilita o compartilhamento, mas não o impõe
- **FlyweightFactory**: Cria e gerencia objetos flyweight; garante que flyweights sejam compartilhados adequadamente; mantém o pool
- **Client**: Mantém referências a flyweights; computa ou armazena estado extrínseco

## Colaborações

- O estado que o flyweight precisa deve ser caracterizado como intrínseco ou extrínseco
- Estado intrínseco armazenado no ConcreteFlyweight; estado extrínseco armazenado ou computado pelos clientes
- Clientes não devem instanciar ConcreteFlyweights diretamente; devem obtê-los da FlyweightFactory

## Consequências

### Vantagens

- **Economia de memória**: Reduz significativamente o uso de memória quando há muitos objetos similares
- **Custo de tempo de execução vs armazenamento**: Pode introduzir custo em tempo de execução para transferir, encontrar ou computar estado extrínseco
- **Reutilização de objetos**: Promove reutilização extensiva de objetos

### Desvantagens

- **Complexidade**: Aumenta a complexidade do código ao separar estado intrínseco/extrínseco
- **Estado extrínseco**: O cliente deve manter e passar o estado extrínseco
- **Dificuldade de testes**: Objetos compartilhados podem ter efeitos colaterais entre testes

## Implementação

### Considerações

1. **Remover estado extrínseco**: A aplicabilidade do padrão não vale a pena se não houver objetos suficientes para fazer diferença significativa de armazenamento

2. **Gerenciar objetos compartilhados**: Clientes não devem instanciar ConcreteFlyweights diretamente; FlyweightFactory decide quando criar e compartilhar

3. **Compartilhamento implica imutabilidade**: Flyweights compartilhados não devem permitir modificação do estado intrínseco

4. **Coleta de lixo**: Em linguagens com GC, flyweights não utilizados podem ser coletados; o pool pode usar referências fracas

### Técnicas

- **Criação Preguiçosa**: Crie flyweights sob demanda
- **String Interning**: Técnica similar usada para strings
- **Object Pool**: Flyweight usa o padrão Object Pool
- **Referências Fracas**: Para permitir coleta pelo GC de flyweights não utilizados

## Usos Conhecidos

- **String Interning**: Java, Python, JavaScript fazem interning de literais de string
- **Cache de Integer**: Java armazena em cache objetos Integer de -128 a 127
- **Conjuntos de Caracteres**: Objetos que representam caracteres em editores
- **Objetos de Jogo**: Texturas, modelos 3D compartilhados entre múltiplas instâncias
- **Pools de Conexão de Banco de Dados**: Compartilham conexões custosas
- **Thread Pools**: Compartilham threads entre tarefas

## Padrões Relacionados

- [**Composite**](003_composite.md): Frequentemente combinados; nós folha podem ser flyweights
- **State/Strategy**: Objetos State e Strategy frequentemente são flyweights (sem estado)
- [**Singleton**](../creational/005_singleton.md): FlyweightFactory frequentemente é singleton
- **Factory**: FlyweightFactory é uma variante do padrão Factory
- **Object Pool**: Similar, mas focado em reutilização temporal; Flyweight foca em compartilhamento espacial

### Relação com Rules

- [029 - Object Immutability](../../clean-code/imutabilidade-objetos-freeze.md): flyweights devem ser imutáveis
- [036 - Restriction on Functions with Side Effects](../../clean-code/restricao-funcoes-efeitos-colaterais.md): sem efeitos colaterais
- [045 - Stateless Processes](../../twelve-factor/006_processos-stateless.md): flyweights sem estado mutável

---

**Criado em**: 2025-01-11
**Versão**: 1.0
