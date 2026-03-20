# Template Method

**Classificação**: Padrão Comportamental

---

## Intenção e Objetivo

Definir o esqueleto de um algoritmo em uma operação, adiando algumas etapas para as subclasses. Template Method permite que subclasses redefinam certas etapas de um algoritmo sem alterar sua estrutura.

## Também Conhecido Como

- Template Method
- Hollywood Principle ("Don't call us, we'll call you")

## Motivação

Considere um framework de aplicação que fornece classes Application e Document. A classe Application é responsável por abrir documentos existentes armazenados em um formato externo, como um arquivo. Um objeto Document representa as informações em um documento depois que ele é aberto.

Aplicações construídas com o framework podem criar subclasses de Application e Document para atender às necessidades específicas. Por exemplo, uma aplicação de desenho define subclasses DrawApplication e DrawDocument. A classe Application define o algoritmo para abrir e ler um documento em um template method chamado OpenDocument. OpenDocument define cada etapa para abrir um documento: pode verificar se o documento pode ser aberto, criar um objeto Document, ler o arquivo, adicionar o documento ao seu conjunto de documentos. Chamamos OpenDocument de template method porque define um algoritmo com algumas etapas abstratas (CreateDocument, DoRead) que as subclasses devem implementar.

## Aplicabilidade

Use o padrão Template Method quando:

- Para implementar as partes invariantes de um algoritmo uma única vez e deixar para as subclasses implementarem o comportamento que pode variar
- Comportamento comum entre subclasses deve ser fatorado e localizado em uma classe comum para evitar duplicação de código
- Para controlar extensões de subclasses; você pode definir um template method que chama operações de "hook" em pontos específicos, permitindo assim extensões apenas nesses pontos
- Você deseja inverter o controle (Princípio Hollywood)
- Você tem um algoritmo com etapas fixas mas implementações variáveis

## Estrutura

```
AbstractClass
├── templateMethod() [final]
│   ├── primitiveOperation1()
│   ├── primitiveOperation2()
│   └── hook() [opcional]
├── primitiveOperation1() [abstract]
└── primitiveOperation2() [abstract]
└── hook() [implementação vazia - opcional]

ConcreteClass extends AbstractClass
├── primitiveOperation1()
│   └── Implementação específica
└── primitiveOperation2()
    └── Implementação específica
└── hook() [override opcional]
```

## Participantes

- **AbstractClass**: Define operações primitivas abstratas que as subclasses concretas definem para implementar as etapas de um algoritmo; implementa um template method definindo o esqueleto de um algoritmo; o template method chama operações primitivas assim como operações definidas na AbstractClass ou as de outros objetos
- **ConcreteClass**: Implementa as operações primitivas para realizar as etapas específicas da subclasse do algoritmo

## Colaborações

- ConcreteClass depende de AbstractClass para implementar as etapas invariantes do algoritmo

## Consequências

### Vantagens

- **Reutilização de código**: Código comum fatorado na classe base
- **Inversão de controle**: Classe base chama operações de uma subclasse e não o contrário
- **Pontos de extensão bem definidos**: Operações de hook fornecem comportamento padrão que as subclasses podem sobrescrever se necessário
- **Open/Closed Principle**: Aberto para extensão (subclasses) mas fechado para modificação (template method)

### Desvantagens

- **Pode levar a hierarquias complexas**: Muitas operações primitivas podem tornar templates difíceis de entender
- **Depuração difícil**: Fluxo de controle invertido pode dificultar a depuração
- **Violação de Liskov**: Se o template method assume muito sobre as subclasses

## Implementação

### Considerações

1. **Usando controle de acesso**: Template methods devem ser protegidos para serem sobrescritos; operações primitivas podem ser protegidas para acesso apenas pelo template method

2. **Minimizando operações primitivas**: Quanto menos operações primitivas precisarem ser sobrescritas, mais fácil para os clientes

3. **Convenções de nomenclatura**: Podem ser usadas convenções para identificar operações que devem ser sobrescritas

4. **Usando final/sealed**: O template method pode ser marcado como final para evitar sobrescrita

### Técnicas

- **Operações Hook**: Operações com implementação vazia padrão que podem ser sobrescritas
- **Obrigatórias vs Opcionais**: Distinguir operações obrigatórias (abstratas) das opcionais (hook)
- [**Factory Method**](../creational/003_factory-method.md): Template Method frequentemente usa Factory Methods
- **Pontos Congelados vs Pontos Quentes**: Template method é ponto congelado; operações primitivas são pontos quentes

## Usos Conhecidos

- **Métodos de Ciclo de Vida de Framework**: React (componentDidMount, render), Angular (ngOnInit)
- **HTTP Servlets**: Método service() chama doGet(), doPost()
- **Frameworks de Teste Unitário**: setUp(), test(), tearDown()
- **Pipelines de Processamento de Dados**: extract(), transform(), load()
- **Loops de Jogo**: initialize(), update(), render(), cleanup()
- **Algoritmos de Ordenação**: Template para sort com método de comparação variável

## Padrões Relacionados

- [**Factory Method**](../creational/003_factory-method.md): Frequentemente chamado por template methods
- [**Strategy**](009_strategy.md): Template Method usa herança para variar parte de um algoritmo; Strategy usa composição
- [**Command**](002_command.md): Commands podem usar template method para definir a estrutura de execução
- [**Visitor**](011_visitor.md): Template Method pode ser usado para definir o esqueleto de percurso

### Relação com Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): extensão via herança
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separar invariante do variante
- [021 - Prohibition of Logic Duplication](../../clean-code/proibicao-duplicacao-logica.md): elimina duplicação nas subclasses
- [001 - Single Level of Indentation](../../object-calisthenics/001_nivel-unico-indentacao.md): dividir em métodos pequenos

---

**Criado em**: 2025-01-11
**Versão**: 1.0
