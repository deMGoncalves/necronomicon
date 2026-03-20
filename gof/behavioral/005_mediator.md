# Mediator

**Classificação**: Padrão Comportamental

---

## Intenção e Objetivo

Definir um objeto que encapsula como um conjunto de objetos interage. Mediator promove o acoplamento fraco ao evitar que objetos se refiram uns aos outros explicitamente, e permite variar suas interações independentemente.

## Também Conhecido Como

- Mediator
- Intermediary

## Motivação

O design orientado a objetos incentiva a distribuição de comportamento entre objetos. Tal distribuição pode resultar em muitas conexões entre objetos; no pior caso, cada objeto conhece todos os outros. Embora particionar um sistema em muitos objetos geralmente melhore a reusabilidade, a proliferação de interconexões tende a reduzi-la novamente.

Muitas interconexões tornam menos provável que um objeto possa funcionar sem o suporte dos outros. Mediator resolve isso encapsulando o comportamento coletivo em um objeto separado. Um mediator é responsável por controlar e coordenar as interações de um grupo de objetos. Ele serve como um intermediário que evita que os objetos do grupo se refiram uns aos outros explicitamente. Os objetos conhecem apenas o mediator, reduzindo o número de interconexões.

## Aplicabilidade

Use o padrão Mediator quando:

- Um conjunto de objetos se comunica de formas bem definidas mas complexas
- Reutilizar um objeto é difícil porque ele se refere e se comunica com muitos outros objetos
- O comportamento distribuído entre várias classes deve ser customizável sem muita herança
- Você deseja desacoplar colegas que se comunicam entre si
- Você tem classes altamente acopladas que são difíceis de modificar

## Estrutura

```
Mediator (Interface)
└── notify(sender, event)

ConcreteMediator implements Mediator
├── Conhece: Colleague1, Colleague2, ColleagueN
└── notify(sender, event)
    ├── Coordena a comunicação entre colegas
    └── Implementa a lógica de interação

Colleague (Interface/Abstrato)
├── Compõe: Mediator
└── Comunica via: mediator.notify(this, event)

ConcreteColleague1 implements Colleague
└── operation()
    └── mediator.notify(this, "event1")

ConcreteColleague2 implements Colleague
└── operation()
    └── mediator.notify(this, "event2")
```

## Participantes

- [**Mediator**](005_mediator.md): Define a interface para comunicação com objetos Colleague
- **ConcreteMediator**: Implementa o comportamento cooperativo coordenando objetos Colleague; conhece e mantém seus colegas
- **Classes Colleague**: Cada classe Colleague conhece seu objeto Mediator; cada colega se comunica com seu mediator sempre que se comunicaria com outro colega

## Colaborações

- Colegas enviam e recebem solicitações de um objeto Mediator
- O mediator implementa o comportamento cooperativo roteando solicitações entre os colegas adequados

## Consequências

### Vantagens

- **Limita a herança**: Localiza o comportamento que de outra forma estaria distribuído entre vários objetos; alterar o comportamento requer apenas herdar de Mediator
- **Desacopla colegas**: Mediator promove acoplamento fraco entre colegas; pode variar e reutilizar classes Colleague e Mediator independentemente
- **Simplifica protocolos de objetos**: Substitui comunicações muitos-para-muitos por um-para-muitos; um-para-muitos é mais fácil de entender, manter e estender
- **Abstrai a cooperação entre objetos**: Mediator separa como os objetos cooperam de sua lógica individual
- **Centraliza o controle**: Troca a complexidade da interação pela complexidade no mediator

### Desvantagens

- **Centralização pode criar monólito**: Mediator pode se tornar um monólito complexo e difícil de manter
- **Mediator pode se tornar um God Object**: Se concentrar responsabilidades demais

## Implementação

### Considerações

1. **Omitindo a classe Mediator abstrata**: Quando colegas trabalham com apenas um mediator, a abstração não é necessária

2. **Comunicação Colleague-Mediator**: Usar o padrão Observer para comunicar mudanças de estado

3. **Evitando o God Mediator**: Se o mediator se tornar muito complexo, dividir responsabilidades ou usar Chain of Responsibility

### Técnicas

- **Observer para notificações**: Colegas observam mudanças via mediator
- **Comunicação baseada em eventos**: Usar eventos para desacoplar ainda mais
- **Baseado em mensagens**: Usar mensagens tipadas para comunicação
- **Cadeia de mediators**: Mediators podem formar uma cadeia para delegação

## Usos Conhecidos

- **Frameworks GUI**: Caixas de diálogo coordenando widgets (controller do MVC)
- **Controle de Tráfego Aéreo**: Coordenação entre aviões e torre
- **Salas de Chat**: Servidor que media mensagens entre usuários
- **Event Buses**: Mediators de eventos em aplicações
- **MVC Controller**: Coordena Model e View
- **Service Bus**: Enterprise Service Bus coordena serviços

## Padrões Relacionados

- [**Facade**](010_facade.md): Abstrai subsistema para simplificar a interface; Mediator abstrai a comunicação entre colegas cooperantes
- [**Observer**](007_observer.md): Colegas podem se comunicar com o mediator usando o padrão Observer
- [**Singleton**](../creational/005_singleton.md): Mediator é frequentemente um singleton
- [**Strategy**](009_strategy.md): Mediator pode usar Strategy para variar o comportamento de coordenação
- [**Command**](002_command.md): Commands podem ser mediados pelo mediator

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): centralizar coordenação
- [005 - Call Chaining Restriction](../../object-calisthenics/005_maximo-uma-chamada-por-linha.md): evitar comunicação direta
- [009 - Tell, Don't Ask](../../object-calisthenics/009_diga-nao-pergunte.md): colegas notificam o mediator
- [025 - Prohibition of The Blob Anti-Pattern](../../clean-code/proibicao-anti-padrao-blob.md): evitar God Mediator

---

**Criado em**: 2025-01-11
**Versão**: 1.0
