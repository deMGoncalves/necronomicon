# Bridge

**Classificação**: Padrão Estrutural

---

## Intenção e Objetivo

Desacoplar uma abstração de sua implementação para que as duas possam variar independentemente. Permite que abstração e implementação sejam desenvolvidas separadamente e que o código cliente se relacione com a interface abstrata.

## Também Conhecido Como

- Handle/Body

## Motivação

Quando uma abstração pode ter uma de várias implementações possíveis, a forma usual de acomodá-las é através de herança. Mas a herança vincula permanentemente uma implementação à abstração, tornando difícil modificar, estender e reutilizar abstrações e implementações de forma independente.

Considere classes Window portáteis que devem funcionar no X Window System e no IBM Presentation Manager. Usar herança para definir WindowXWindow e WindowPM dificulta compor Window com diferentes abstrações de janela (IconWindow, TransientWindow). Teríamos que criar versões específicas de plataforma para cada tipo: XIconWindow, PMIconWindow, XTransientWindow, PMTransientWindow — explosão de classes.

O padrão Bridge evita isso separando a hierarquia de abstração (Window) da hierarquia de implementação (WindowImpl). Window mantém referência a WindowImpl e delega operações dependentes de implementação.

## Aplicabilidade

Use o padrão Bridge quando:

- Você quer evitar vínculo permanente entre abstração e implementação (como quando a implementação deve ser selecionada ou trocada em tempo de execução)
- Tanto as abstrações quanto as implementações devem ser extensíveis por subclassing
- Mudanças na implementação de uma abstração não devem impactar os clientes
- Você quer compartilhar uma implementação entre múltiplos objetos e ocultar esse fato do cliente
- Você tem proliferação de classes resultante de uma hierarquia bidimensional
- Você quer dividir uma classe monolítica que possui várias variantes de funcionalidade

## Estrutura

```
Client
└── Uses: Abstraction
    └── operation()

Abstraction
├── Composes: Implementor (interface)
└── operation()
    └── Delegates to: implementor.operationImpl()

RefinedAbstraction extends Abstraction
└── Can add operations or refine existing ones

Implementor (Interface)
└── operationImpl()

ConcreteImplementorA implements Implementor
└── operationImpl() → specific implementation A

ConcreteImplementorB implements Implementor
└── operationImpl() → specific implementation B
```

## Participantes

- **Abstraction**: Define a interface da abstração; mantém referência a um objeto do tipo Implementor
- **RefinedAbstraction**: Estende a interface definida por Abstraction
- **Implementor**: Define a interface para as classes de implementação; não precisa corresponder exatamente à interface de Abstraction
- **ConcreteImplementor**: Implementa a interface Implementor e define sua implementação concreta

## Colaborações

- Abstraction encaminha requisições dos clientes para seu objeto Implementor

## Consequências

### Vantagens

- **Desacopla interface e implementação**: A implementação não está permanentemente vinculada à interface
- **Melhora a extensibilidade**: Estenda as hierarquias de Abstraction e Implementor de forma independente
- **Oculta detalhes de implementação**: Pode ocultar detalhes dos clientes
- **Reduz recompilações**: Mudança na implementação não requer recompilação de Abstraction e clientes
- **Compartilhamento de implementação**: Múltiplas abstrações podem compartilhar a mesma implementação

### Desvantagens

- **Aumenta a complexidade**: Introduz indireção adicional
- **Overhead**: Leve penalidade de desempenho devido à delegação

## Implementação

### Considerações

1. **Apenas um Implementor**: Bridge ainda é útil mesmo com apenas uma implementação se você quiser evitar acoplamento

2. **Criando o objeto Implementor correto**: Como e onde decidir qual ConcreteImplementor instanciar
   - Se Abstraction conhece todos os ConcreteImplementors, pode instanciar o apropriado no construtor
   - Delegar a decisão para outro objeto (Factory, Abstract Factory)
   - Escolher implementação padrão e alterá-la posteriormente conforme necessário

3. **Compartilhando implementors**: Use contagem de referências quando o Implementor é compartilhado

4. **Herança múltipla**: Pode usar herança múltipla para combinar abstração e implementação, mas vincula as duas

### Técnicas

- **Factory para Implementors**: Use Factory para escolher a implementação adequada
- **Strategy dentro do Bridge**: O Implementor pode ser o padrão Strategy
- **Inicialização preguiçosa**: Adie a criação do Implementor até que seja necessário pela primeira vez

## Usos Conhecidos

- **JDBC**: Interface de driver (Implementor) e Connection/Statement (Abstraction)
- **Frameworks GUI**: Abstract window toolkit e implementações específicas de plataforma
- **Coleções**: Interface (Abstraction) e implementações específicas (ArrayList, LinkedList)
- **Renderização Gráfica**: Abstração de desenho e motores de renderização (DirectX, OpenGL, Vulkan)
- **Drivers de Dispositivo**: Abstração de dispositivo e drivers específicos
- **Camadas de Persistência**: Abstração ORM e implementações específicas de banco de dados

## Padrões Relacionados

- [**Abstract Factory**](../creational/001_abstract-factory.md): Pode criar e configurar um Bridge específico
- [**Adapter**](001_adapter.md): Muda a interface de um objeto existente; Bridge separa interface de implementação de forma proativa
- **State/Strategy**: As implementações podem ser States ou Strategies
- [**Template Method**](../gof/behavioral/010_template-method.md): Herança para variar algoritmo; Bridge usa composição para variar implementação

### Relação com Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): permite extensão independente
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): abstração depende de interface
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separa responsabilidades
- [013 - Interface Segregation Principle](../../solid/004_interface-segregation-principle.md): interfaces específicas

---

**Criado em**: 2025-01-11
**Versão**: 1.0
