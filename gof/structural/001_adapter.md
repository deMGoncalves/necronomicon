# Adapter

**Classificação**: Padrão Estrutural

---

## Intenção e Objetivo

Converter a interface de uma classe em outra interface esperada pelos clientes. O Adapter permite que classes com interfaces incompatíveis trabalhem juntas, envolvendo-se com uma interface compatível.

## Também Conhecido Como

- Wrapper

## Motivação

Às vezes uma classe de toolkit projetada para reutilização não pode ser reutilizada simplesmente porque sua interface não corresponde à interface específica do domínio exigida por uma aplicação. Considere um editor gráfico que permite desenhar e organizar elementos gráficos. A interface do editor define abstrações como Shape para objetos gráficos. Mas existe uma classe TextView herdada que implementa janelas de texto, e você quer reutilizá-la.

A solução é definir uma classe TextShape que adapta a interface do TextView à interface Shape. TextShape é um adaptador que permite ao editor tratar TextView como se fosse um Shape.

## Aplicabilidade

Use o padrão Adapter quando:

- Você quer usar uma classe existente, mas sua interface não corresponde à que você precisa
- Você quer criar uma classe reutilizável que coopere com classes não relacionadas ou imprevistas com interfaces incompatíveis
- (Apenas adaptador de objeto) Você precisa usar várias subclasses existentes, mas é impraticável adaptar sua interface por subclassing. Um adaptador de objeto pode adaptar a interface de sua classe pai
- Você quer isolar seu código de dependências externas (Camada Anticorrupção)
- Você precisa integrar código legado com código novo

## Estrutura

### Adaptador de Objeto (Composição)
```
Client
└── Uses: Target (Interface)
    └── request()

Adapter implements Target
├── Composes: Adaptee
└── request()
    └── Translates to: adaptee.specificRequest()

Adaptee
└── specificRequest()
```

### Adaptador de Classe (Herança)
```
Client
└── Uses: Target (Interface)

Adapter extends Adaptee implements Target
└── request()
    └── Calls: this.specificRequest()
```

## Participantes

- **Target**: Define a interface específica do domínio que o Client utiliza
- **Client**: Colabora com objetos que seguem a interface Target
- **Adaptee**: Define uma interface existente que precisa ser adaptada
- [**Adapter**](001_adapter.md): Adapta a interface do Adaptee para a interface Target

## Colaborações

- Clientes chamam operações na instância do Adapter
- O Adapter chama operações do Adaptee que executam a requisição

## Consequências

### Adaptador de Classe (Herança)
**Vantagens**:
- Adapta o Adaptee ao Target ao se comprometer com uma classe Adaptee concreta
- Permite que o Adapter substitua parte do comportamento do Adaptee
- Introduz apenas um objeto; sem indireção adicional de ponteiro para chegar ao adaptee

**Desvantagens**:
- Não funciona quando queremos adaptar uma classe e todas as suas subclasses
- Requer herança múltipla (não disponível em muitas linguagens)

### Adaptador de Objeto (Composição)
**Vantagens**:
- Permite que um único Adapter trabalhe com múltiplos Adaptees
- Facilita adicionar funcionalidade a todos os Adaptees de uma vez
- Mais flexível (composição preferida sobre herança)

**Desvantagens**:
- Dificulta a substituição do comportamento do Adaptee
- Requer referência ao Adaptee

## Implementação

### Considerações

1. **Quanto de adaptação fazer**: O trabalho varia desde simples conversão de nomes de operações até suportar um conjunto completamente diferente de operações

2. **Adaptadores plugáveis**: Maximize a reutilização usando adaptadores que se adaptam a diferentes clientes. Construa interface mínima, use operações abstratas, use delegates

3. **Adaptadores bidirecionais**: Suporte múltiplas visões de um objeto (herança múltipla)

4. **Interface mínima**: O Adapter deve expor apenas o necessário

### Técnicas

- **Padrão Delegate**: Delega chamadas ao Adaptee
- **Interface Adapter**: Cria adaptador que implementa a interface completa com métodos vazios; subclasses substituem o que for necessário
- **Function Adapter**: Para adaptar funções isoladas

## Usos Conhecidos

- **Collections Framework**: `Arrays.asList()` adapta array para List
- **I/O Streams**: `InputStreamReader` adapta InputStream para Reader
- **Tratamento de Eventos**: Classes adaptadoras em listeners (MouseAdapter, KeyAdapter)
- **Integração de Código Legado**: Encapsulamento de sistemas legados para uso em arquiteturas modernas
- **Bibliotecas de Terceiros**: Adaptação de bibliotecas externas para interfaces internas
- **Camada Anticorrupção**: DDD - protege o domínio de sistemas externos

## Padrões Relacionados

- [**Bridge**](002_bridge.md): Similar, mas com intenção diferente; Bridge separa interface de implementação para que possam variar independentemente; Adapter muda a interface de um objeto existente
- [**Decorator**](004_decorator.md): Aprimora outro objeto sem mudar a interface; mais transparente que o Adapter; suporta composição recursiva
- [**Proxy**](007_proxy.md): Define um representante para outro objeto sem mudar a interface
- [**Facade**](005_facade.md): Define nova interface; Adapter reutiliza a interface antiga

### Relação com Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): reforça
- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): implementa
- [012 - Liskov Substitution Principle](../../solid/003_liskov-substitution-principle.md): reforça
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): adaptar é responsabilidade única

---

**Criado em**: 2025-01-11
**Versão**: 1.0
