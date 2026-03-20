# Decorator

**Classificação**: Padrão Estrutural

---

## Intenção e Objetivo

Anexar responsabilidades adicionais a um objeto de forma dinâmica. Os Decorators fornecem uma alternativa flexível à subclassificação para estender funcionalidades, permitindo que comportamentos sejam adicionados a objetos individuais, em vez de a uma classe inteira.

## Também Conhecido Como

- Wrapper

## Motivação

Às vezes queremos adicionar responsabilidades a objetos individuais, não a uma classe inteira. Um toolkit gráfico deve permitir adicionar propriedades como bordas ou rolagem a qualquer componente de interface do usuário. Uma forma seria herança, mas isso é inflexível: a borda é adicionada de forma estática. O cliente não pode controlar como e quando decorar o componente.

Uma abordagem mais flexível é envolver o componente em outro objeto que adiciona a borda. O objeto envolvente é o decorator, que segue a interface do componente que decora. O Decorator encaminha requisições para o componente e pode realizar ações adicionais. A transparência permite decorar o decorator recursivamente, permitindo um número ilimitado de responsabilidades adicionadas.

## Aplicabilidade

Use o padrão Decorator quando:

- Adicionar responsabilidades a objetos individuais de forma dinâmica e transparente, sem afetar outros objetos
- Para responsabilidades que podem ser retiradas
- Quando a extensão por subclassificação é impraticável (causaria explosão de subclasses)
- Você precisa adicionar funcionalidade a objetos em tempo de execução
- Você quer combinar vários comportamentos por meio de composição
- Você quer adicionar comportamento sem modificar código existente (OCP)

## Estrutura

```
Client
└── Uses: Component (Interface)
    └── operation()

Component (Interface)
└── operation()

ConcreteComponent implements Component
└── operation() → base implementation

Decorator implements Component
├── Composes: Component wrappedComponent
└── operation()
    └── Delegates to: wrappedComponent.operation()

ConcreteDecoratorA extends Decorator
└── operation()
    ├── Additional behavior before
    ├── super.operation()
    └── Additional behavior after

ConcreteDecoratorB extends Decorator
├── Additional state: addedState
└── operation()
    ├── Uses addedState
    └── super.operation()
```

## Participantes

- **Component**: Define a interface para objetos que podem ter responsabilidades adicionadas a eles dinamicamente
- **ConcreteComponent**: Define o objeto ao qual responsabilidades adicionais podem ser anexadas
- [**Decorator**](004_decorator.md): Mantém referência a um objeto Component e define interface que segue a interface do Component
- **ConcreteDecorator**: Adiciona responsabilidades ao componente

## Colaborações

- O Decorator encaminha requisições ao seu objeto Component
- Pode opcionalmente realizar operações adicionais antes/depois de encaminhar

## Consequências

### Vantagens

- **Mais flexível que herança estática**: Adicione/remova responsabilidades em tempo de execução
- **Evita classes sobrecarregadas de funcionalidades**: Pague apenas pela funcionalidade utilizada; a funcionalidade pode ser composta de peças simples
- **Facilita a personalização incremental**: Aplique decorators progressivamente
- **Respeita o Princípio Aberto/Fechado**: Estende funcionalidade sem modificar classes existentes
- **Responsabilidade Única**: Divide funcionalidade entre classes especializadas

### Desvantagens

- **Muitos objetos pequenos**: O design pode resultar em muitos objetos pequenos e similares, tornando aprendizado e depuração difíceis
- **Identidade de objeto**: Decorator e componente decorado não são idênticos; testes de identidade falham
- **Complexidade**: Uma longa cadeia de decorators pode ser difícil de entender e depurar

## Implementação

### Considerações

1. **Conformidade de interface**: O Decorator deve seguir a interface do componente que decora

2. **Omitir a classe Decorator abstrata**: Quando apenas uma responsabilidade precisa ser adicionada, o Decorator abstrato não é necessário

3. **Manter o Component leve**: O Component deve focar na interface, não armazenar dados; caso contrário, a complexidade dos decorators aumenta

4. **Mudar a casca vs mudar as entranhas**: Decorator muda a casca (interface); Strategy muda as entranhas (algoritmo)

### Técnicas

- **Cadeia de Decorators**: Encadeie múltiplos decorators
- **Encapsulamento Transparente**: O Decorator é completamente transparente para o cliente
- **Decorator Semitransparente**: O Decorator adiciona métodos à interface
- **Decorators Imutáveis**: Decorators que não modificam estado

## Usos Conhecidos

- **Java I/O Streams**: `BufferedInputStream`, `DataInputStream` decoram `InputStream`
- **Coleções Java**: `UnmodifiableList`, `SynchronizedList` decoram `List`
- **Decorators de Log**: Adicionam logging a componentes
- **Decorators de Cache**: Adicionam cache a repositórios ou serviços
- **Decorators de Transação**: Adicionam controle transacional
- **Retry/Circuit Breaker**: Adicionam resiliência a chamadas

## Padrões Relacionados

- [**Adapter**](001_adapter.md): Muda a interface; Decorator aprimora responsabilidades
- [**Composite**](003_composite.md): Estruturalmente similar; Decorator adiciona responsabilidades, Composite agrega
- [**Strategy**](../gof/behavioral/009_strategy.md): Muda as entranhas do objeto; Decorator muda a casca
- [**Proxy**](007_proxy.md): Controla acesso; Decorator adiciona funcionalidade
- [**Chain of Responsibility**](013_chain-of-responsibility.md): Decorator pode implementar cadeia encaminhando para o decorado

### Relação com Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): implementa (extensão sem modificação)
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): cada decorator tem uma responsabilidade
- [012 - Liskov Substitution Principle](../../solid/003_liskov-substitution-principle.md): decorator substitui o componente
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): depende de abstração

---

**Criado em**: 2025-01-11
**Versão**: 1.0
