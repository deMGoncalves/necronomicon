# Observer

**Classificação**: Padrão Comportamental

---

## Intenção e Objetivo

Definir uma dependência um-para-muitos entre objetos, de modo que quando um objeto muda de estado, todos os seus dependentes são notificados e atualizados automaticamente. Permite comunicação fracamente acoplada entre objetos.

## Também Conhecido Como

- Dependents
- Publish-Subscribe
- Event-Listener
- Signals and Slots

## Motivação

Um efeito colateral comum de particionar um sistema em uma coleção de classes cooperantes é a necessidade de manter consistência entre objetos relacionados. Você não quer alcançar a consistência tornando as classes fortemente acopladas, porque isso reduz sua reusabilidade.

Considere um toolkit de GUI que separa os aspectos de apresentação dos dados dos dados subjacentes. As classes que definem dados de aplicação e apresentações podem ser reutilizadas independentemente. Elas podem trabalhar juntas: uma planilha e um gráfico de barras podem retratar informações no mesmo objeto de dados da aplicação. A planilha e o gráfico não se conhecem; isso permite reutilizá-los separadamente. Mas eles se comportam como se se conhecessem: quando um usuário muda informação na planilha, o gráfico reflete a mudança imediatamente, e vice-versa.

Os objetos chave são subject e observer. Um subject pode ter qualquer número de observers dependentes. Todos os observers são notificados sempre que o subject sofre uma mudança de estado. Em resposta, cada observer consultará o subject para sincronizar seu estado com o do subject.

## Aplicabilidade

Use o padrão Observer quando:

- Uma abstração tem dois aspectos, um dependente do outro; encapsulá-los em objetos separados permite variá-los e reutilizá-los independentemente
- Uma mudança em um objeto requer alterar outros, e você não sabe quantos objetos precisam ser alterados
- Um objeto deve ser capaz de notificar outros objetos sem fazer suposições sobre quem são esses objetos (baixo acoplamento)
- Você deseja implementar tratamento de eventos
- Você precisa de broadcasting de mudanças

## Estrutura

```
Subject (Interface/Abstrato)
├── Mantém: List<Observer> observers
├── attach(Observer)
├── detach(Observer)
└── notify()
    └── Para cada observer: observer.update(this)

ConcreteSubject extends Subject
├── Mantém: estado interno
├── getState() → retorna estado
└── setState(state)
    └── Atualiza estado e chama notify()

Observer (Interface)
└── update(subject: Subject)

ConcreteObserver implements Observer
├── Mantém: referência ao subject
└── update(subject)
    └── Sincroniza estado com subject.getState()
```

## Participantes

- **Subject**: Conhece seus observers; qualquer número de objetos Observer pode observar um subject; fornece interface para anexar e desanexar observers
- [**Observer**](007_observer.md): Define uma interface de atualização para objetos que devem ser notificados de mudanças em um subject
- **ConcreteSubject**: Armazena o estado de interesse para objetos ConcreteObserver; envia notificação para seus observers quando seu estado muda
- **ConcreteObserver**: Mantém uma referência a um objeto ConcreteSubject; armazena estado que deve permanecer consistente com o do subject; implementa a interface de atualização do Observer

## Colaborações

- ConcreteSubject notifica seus observers sempre que ocorre uma mudança que poderia tornar o estado dos observers inconsistente com o seu
- Após ser informado de uma mudança no concrete subject, um objeto ConcreteObserver pode consultar o subject por informações; usa essas informações para reconciliar seu estado com o do subject

## Consequências

### Vantagens

- **Acoplamento abstrato entre Subject e Observer**: Subject não conhece as classes concretas de seus observers; o acoplamento é abstrato e mínimo
- **Suporte a comunicação por broadcast**: A notificação é transmitida automaticamente para todos os objetos interessados
- **Atualizações inesperadas**: Observers não têm consciência uns dos outros; uma mudança no subject pode causar uma cascata de atualizações

### Desvantagens

- **Atualizações inesperadas**: Observers não têm conhecimento uns dos outros; o custo de uma mudança pode ser inesperado
- **Vazamentos de memória**: Observers não removidos podem causar vazamentos de memória
- **Tempestades de atualização**: Atualizações em cascata podem degradar o desempenho

## Implementação

### Considerações

1. **Mapeando subjects para seus observers**: A forma mais simples é o subject armazenar referências para seus observers

2. **Observando mais de um subject**: Um observer pode observar múltiplos subjects; o subject passa uma referência a si mesmo na atualização para que o observer saiba qual mudou

3. **Quem aciona a atualização**: Subject ou observers
   - Subject após cada mudança (garante consistência mas pode ser ineficiente)
   - Clientes chamam notify após uma série de mudanças (mais eficiente mas arriscado esquecer)

4. **Referências pendentes para subjects excluídos**: Quando um subject é excluído, os observers devem ser notificados

5. **Garantir que o estado do Subject seja consistente antes de notificar**: É importante que o subject esteja em um estado consistente antes de chamar notify

6. **Pull vs Push**: Observers puxam dados do subject (pull) vs subject empurra dados (push)

### Técnicas

- **Modelo Pull**: Observers consultam o subject por mudanças específicas
- **Modelo Push**: Subject envia informações detalhadas para os observers
- **Objetos de Evento**: Passar objeto descrevendo a mudança em vez do subject inteiro
- **Referências Fracas**: Usar referências fracas para evitar vazamentos de memória
- **Notificações Assíncronas**: Notificações assíncronas para operações longas

## Usos Conhecidos

- **Padrão MVC**: Model é o subject, Views são os observers
- **Tratamento de Eventos**: Frameworks GUI (eventos DOM, listeners do Swing)
- **Programação Reativa**: RxJS, Observables, Streams
- **Data Binding**: Data binding bidirecional em frameworks (Vue, Angular, React)
- **Sistemas Pub/Sub**: Message brokers, event buses
- **Mercado de Ações**: Atualizações de preços para assinantes

## Padrões Relacionados

- [**Mediator**](005_mediator.md): Encapsular comunicação complexa entre colegas usando Mediator; Observer distribui a comunicação introduzindo Observer e Subject
- [**Singleton**](../creational/005_singleton.md): Subject é frequentemente um Singleton
- [**Command**](002_command.md): Observer pode usar Command para encapsular a operação de atualização
- [**Strategy**](009_strategy.md): Observer pode usar Strategy para definir diferentes estratégias de atualização
- [**Template Method**](010_template-method.md): A atualização pode ser um template method

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separar mudança de notificação
- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): adicionar observers sem modificar o subject
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): subject depende da interface Observer

---

**Criado em**: 2025-01-11
**Versão**: 1.0
