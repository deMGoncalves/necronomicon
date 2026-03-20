# Singleton

**Classificação**: Padrão Criacional

---

## Intenção e Objetivo

Garantir que uma classe tenha apenas uma instância e fornecer um ponto global de acesso a ela. Controla o acesso a recursos compartilhados como conexões de banco de dados ou arquivos.

## Também Conhecido Como

- Single Instance

## Motivação

É importante que algumas classes tenham exatamente uma instância. Embora possa haver muitas impressoras em um sistema, deve haver apenas um spooler de impressão. Deve haver apenas um sistema de arquivos e um gerenciador de janelas.

Como garantir que uma classe tenha apenas uma instância e que ela seja facilmente acessível? Uma variável global torna o objeto acessível, mas não impede a instanciação de múltiplos objetos. A solução é tornar a própria classe responsável por manter sua instância única, garantindo que nenhuma outra possa ser criada.

## Aplicabilidade

Use o padrão Singleton quando:

- Deve existir exatamente uma instância de uma classe, acessível aos clientes a partir de um ponto bem conhecido
- A instância única deve ser extensível por herança, e os clientes devem poder usar a instância estendida sem modificar o código
- Você precisa de controle mais rigoroso sobre variáveis globais
- Recursos custosos devem ser compartilhados (conexões, pools de threads)
- Um objeto coordenador central é necessário (event bus, logger)

## Estrutura

```
Singleton
├── Propriedade estática privada: instance
├── Construtor privado/protegido
└── Método estático público getInstance()
    ├── Se instance é nulo
    │   └── instance = new Singleton()
    └── Retorna instance

Client
└── Acessa: Singleton.getInstance()
```

## Participantes

- [**Singleton**](005_singleton.md): Define a operação getInstance() que permite aos clientes acessar sua instância única; getInstance() é uma operação de classe (método estático); pode ser responsável por criar sua própria instância única

## Colaborações

- Clientes acessam a instância Singleton exclusivamente por meio da operação getInstance()

## Consequências

### Vantagens

- **Acesso controlado**: Encapsula sua instância única, tendo controle sobre como e quando é acessada
- **Namespace reduzido**: Melhora em relação a variáveis globais; evita poluir o namespace
- **Permite refinamento**: Pode ser estendido por herança; configurável para usar a instância desejada
- **Flexível**: Mais flexível do que operações de classe (métodos estáticos); pode mudar a decisão sobre instância única
- **Inicialização preguiçosa**: Instância criada apenas quando necessária

### Desvantagens

- **Violação do SRP**: A classe tem duas responsabilidades (lógica de negócio + controle de instância)
- **Difícil de testar**: Mocks e isolamento são complicados
- **Estado global oculto**: Cria dependências implícitas e acoplamento
- **Concorrência**: Requer cuidado em ambientes multi-thread
- **Violação do DIP**: Clientes dependem da classe concreta

## Implementação

### Considerações

1. **Garantir instância única**: Tornar o construtor privado/protegido

2. **Herança**: Se permitir herança, usar registro de singleton ou fazer getInstance() consultar variável de ambiente/configuração

3. **Thread-safety**: Em ambientes multi-thread, sincronizar acesso a getInstance() ou usar inicialização antecipada

4. **Inicialização preguiçosa vs antecipada**:
   - Preguiçosa: Cria quando primeiro solicitado (economia de recursos)
   - Antecipada: Cria no carregamento da classe (thread-safe por padrão)

5. **Módulos ES6**: Em JavaScript, módulos são naturalmente singletons

### Técnicas

- **Double-checked locking**: Otimizar inicialização preguiçosa em multi-thread
- **Enum Singleton**: Em Java, usar enum para garantir instância única
- **Module Pattern**: Em JavaScript, usar módulo ES6 ou IIFE
- **Injeção de Dependência**: Preferir injetar singleton via DI em vez de chamar getInstance()

## Usos Conhecidos

- **Logger**: `Logger.getInstance()` em várias linguagens
- **Configuration Manager**: Gerenciador de configuração da aplicação
- **Thread Pools**: Pool de threads compartilhado
- **Cache**: Cache global da aplicação
- **Database Connection Pool**: Pool de conexões de banco de dados
- **Event Bus**: Event bus centralizado
- **Window Manager**: Gerenciador de janelas em sistemas operacionais

## Padrões Relacionados

- **Abstract Factory/Builder/Prototype**: Podem ser implementados como Singletons
- [**Facade**](../structural/005_facade.md): Objetos Facade são frequentemente Singletons
- **State/Strategy**: Objetos de estado/strategy sem estado podem ser Singletons
- [**Flyweight**](../structural/006_flyweight.md): A Flyweight Factory é frequentemente Singleton
- **Monostate**: Alternativa que compartilha estado mas permite múltiplas instâncias

### Relação com Rules

- [014 - Dependency Inversion Principle](../../solid/005_dependency-inversion-principle.md): conflita (prefira DI)
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): viola (dupla responsabilidade)
- [032 - Minimum Test Coverage](../../clean-code/cobertura-teste-minima-qualidade.md): dificulta
- [029 - Object Immutability](../../clean-code/imutabilidade-objetos-freeze.md): complementa
- [045 - Stateless Processes](../../twelve-factor/006_processos-stateless.md): conflita

---

**Criado em**: 2025-01-11
**Versão**: 1.0
