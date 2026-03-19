# Strategy

**Classification**: Behavioral Pattern

---

## Intent and Purpose

Define a family of algorithms, encapsulate each one, and make them interchangeable. Strategy lets the algorithm vary independently from clients that use it. Promotes composition over inheritance for varying behavior.

## Also Known As

- Policy

## Motivation

Many algorithms exist for breaking a stream of text into lines. Hard-wiring all such algorithms into the classes that require them isn't desirable for several reasons: clients that need linebreaking become more complex if they include the linebreaking code, making clients bigger and harder to maintain; different algorithms will be appropriate at different times; it's difficult to add new algorithms and vary existing ones when linebreaking is an integral part of a client.

We can avoid these problems by defining classes that encapsulate different linebreaking algorithms. An algorithm that's encapsulated in this way is called a strategy. Composition lets the Composition class maintain a reference to a Strategy object and delegate to it. Swapping in a different Strategy changes how the text is broken.

## Applicability

Use the Strategy pattern when:

- Many related classes differ only in their behavior; Strategies provide a way to configure a class with one of many behaviors
- You need different variants of an algorithm
- An algorithm uses data that clients shouldn't know about; use Strategy to avoid exposing complex data structures
- A class defines many behaviors, and these appear as multiple conditional statements; move each conditional branch into its own Strategy class
- You want to avoid tight coupling between algorithm and code that uses it
- You want to make algorithm interchangeable at runtime

## Structure

```
Context
├── Composes: Strategy
├── contextInterface()
│   └── Delegates to: strategy.algorithmInterface()
└── setStrategy(Strategy)
    └── Allows strategy swapping

Strategy (Interface)
└── algorithmInterface(data)

ConcreteStrategyA implements Strategy
└── algorithmInterface(data)
    └── Algorithm A specific implementation

ConcreteStrategyB implements Strategy
└── algorithmInterface(data)
    └── Algorithm B specific implementation

ConcreteStrategyC implements Strategy
└── algorithmInterface(data)
    └── Algorithm C specific implementation
```

## Participants

- [**Strategy**](009_strategy.md): Declares an interface common to all supported algorithms; Context uses this interface to call the algorithm defined by a ConcreteStrategy
- **ConcreteStrategy**: Implements the algorithm using the Strategy interface
- **Context**: Configured with a ConcreteStrategy object; maintains a reference to a Strategy object; may define an interface that lets Strategy access its data

## Collaborations

- Strategy and Context interact to implement the chosen algorithm; a Context may pass all data required by the algorithm to the Strategy when the algorithm is called; alternatively, Context can pass itself as an argument, letting the Strategy call back on the Context as required
- A Context forwards requests from its clients to its Strategy; Clients usually create and pass a ConcreteStrategy object to the Context; thereafter, clients interact with the Context exclusively

## Consequences

### Advantages

- **Families of related algorithms**: Hierarchies of Strategy classes define a family of algorithms or behaviors for contexts to reuse
- **An alternative to subclassing**: Inheritance offers another way to support a variety of algorithms; but inheritance mixes the algorithm implementation into Context; mixes algorithm with Context, making Context harder to understand, maintain, and extend
- **Eliminates conditional statements**: When different behaviors are lumped into conditional statements, Strategy eliminates conditionals by moving behavior into Strategy classes
- **Choice of implementations**: Strategies can provide different implementations of the same behavior; client can choose among strategies with different time and space trade-offs
- **Open/Closed Principle**: Add new strategies without modifying context

### Disadvantages

- **Clients must be aware of different Strategies**: Clients need to understand how Strategies differ before selecting the appropriate one
- **Communication overhead**: The Strategy interface is shared by all ConcreteStrategies; some may not use all data passed through this interface
- **Increased number of objects**: Strategies increase the number of objects in an application; can reduce this by using Strategies as stateless objects that contexts can share

## Implementation

### Considerations

1. **Defining Strategy and Context interfaces**: Strategy and Context interact to implement the chosen algorithm
   - Context passes data to Strategy (can pass Context as parameter)
   - Context can pass itself as argument allowing Strategy to callback

2. **Strategies as template parameters**: In C++, can use templates to configure a class with a Strategy; only works if Strategy can be selected at compile-time

3. **Making Strategy objects optional**: Context checks if it has a Strategy; if not, carries out default behavior; benefit: clients don't have to deal with Strategy objects unless they don't like the default behavior

4. **Strategy as function**: In languages with first-class functions, can pass function instead of Strategy object

### Techniques

- **Stateless Strategies**: Strategies without state can be shared Flyweights
- **Strategy Factory**: Factory to create appropriate strategies
- **Default Strategy**: Default strategy if none provided
- **Function as Strategy**: In functional languages, use higher-order functions

## Known Uses

- **Sorting Algorithms**: Different sorting algorithms (quicksort, mergesort, heapsort)
- **Compression**: Different compression algorithms (ZIP, RAR, GZIP)
- **Validation**: Different data validation strategies
- **Payment Methods**: Different payment methods (credit card, PayPal, crypto)
- **Route Planning**: Different routing algorithms (shortest, fastest, scenic)
- **Layout Managers**: Different layout strategies in GUIs

## Related Patterns

- [**Flyweight**](011_flyweight.md): Strategy objects often make good flyweights
- [**State**](008_state.md): State can be considered an extension of Strategy; both based on composition; but State lets State object change the Context's state; Strategy just varies the algorithm
- [**Template Method**](010_template-method.md): Defines algorithm skeleton; Strategy defines complete family of algorithms
- [**Command**](002_command.md): Strategy can use Command to parameterize objects with action
- [**Decorator**](009_decorator.md): Changes object's skin; Strategy changes its guts

### Relation to Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): add strategies without modifying context
- [002 - Prohibition of ELSE Clause](../../object-calisthenics/002_proibicao-clausula-else.md): eliminates algorithm conditionals
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): each strategy one responsibility
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): context depends on interface
- [037 - Prohibition of Flag Arguments](../../clean-code/017_proibicao-argumentos-sinalizadores.md): replaces boolean flags

---

**Created on**: 2025-01-11
**Version**: 1.0
