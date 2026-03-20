# Command

**Classificação**: Padrão Comportamental

---

## Intenção e Objetivo

Encapsular uma solicitação como um objeto, permitindo parametrizar clientes com diferentes solicitações, enfileirar ou registrar solicitações e suportar operações desfazíveis.

## Também Conhecido Como

- Action
- Transaction

## Motivação

Às vezes é necessário emitir solicitações a objetos sem saber nada sobre a operação sendo solicitada ou sobre o receptor. Toolkits de GUI incluem objetos como botões e menus que executam uma solicitação em resposta à entrada do usuário. Mas o toolkit não pode implementar a solicitação explicitamente porque apenas a aplicação sabe o que fazer.

O padrão Command permite ao toolkit fazer solicitações a objetos sem saber nada sobre a solicitação ou o receptor. Ele transforma a solicitação em um objeto que pode ser armazenado e passado como outros objetos. A chave é uma interface Command abstrata que declara uma interface para executar operações.

## Aplicabilidade

Use o padrão Command quando quiser:

- Parametrizar objetos com uma ação a ser executada (callbacks em linguagens procedurais)
- Especificar, enfileirar e executar solicitações em momentos diferentes (o command tem tempo de vida independente da solicitação original)
- Suportar desfazer; a operação Execute pode armazenar estado para reverter efeitos; Command tem operação Undo; comandos executados são armazenados em uma lista de histórico
- Suportar registro de alterações para recuperação após falha
- Estruturar um sistema em torno de operações de alto nível construídas sobre primitivas (suporte a transações)

## Estrutura

```
Client
└── Cria: ConcreteCommand e configura Receiver

Invoker
├── Mantém: Command
└── Executa: command.execute()

Command (Interface)
├── execute()
└── undo() (opcional)

ConcreteCommand implements Command
├── Compõe: Receiver
├── Mantém: estado para undo
├── execute()
│   └── receiver.action()
└── undo()
    └── restaura estado

Receiver
└── action() → sabe como executar as operações
```

## Participantes

- [**Command**](002_command.md): Declara a interface para executar uma operação
- **ConcreteCommand**: Define um vínculo entre um objeto Receiver e uma ação; implementa Execute invocando as operações correspondentes no Receiver
- **Client**: Cria um objeto ConcreteCommand e define seu receptor
- **Invoker**: Solicita ao comando que execute a solicitação
- **Receiver**: Sabe como executar as operações associadas ao cumprimento da solicitação; qualquer classe pode servir como Receiver

## Colaborações

- Client cria ConcreteCommand e especifica seu receptor
- Invoker armazena o objeto ConcreteCommand
- Invoker emite a solicitação chamando Execute no comando; quando os comandos são desfazíveis, ConcreteCommand armazena estado antes de invocar Execute
- O objeto ConcreteCommand invoca operações em seu receptor para executar a solicitação

## Consequências

### Vantagens

- **Desacopla invocador do executor**: O objeto que invoca a operação é desacoplado daquele que sabe como executá-la
- **Commands são objetos**: Podem ser manipulados e estendidos como qualquer outro objeto
- **Podem ser compostos em comandos compostos**: Montagem de comandos em compostos
- **Fácil adicionar novos Commands**: Não é necessário alterar classes existentes
- **Suporte a undo/redo**: Armazena histórico de comandos executados
- **Suporte a transações**: Agrupa comandos e os executa atomicamente

### Desvantagens

- **Aumenta o número de classes**: Cada comando concreto requer uma nova classe
- **Complexidade**: Pode complicar o design para operações simples

## Implementação

### Considerações

1. **Quão inteligente deve ser um command**: Varia desde apenas definir um vínculo entre receptor e ações até implementar tudo sem delegar ao receptor

2. **Suportando undo/redo**: ConcreteCommand deve armazenar estado adicional
   - Receiver (objeto que executou a operação)
   - Argumentos para a operação no receptor
   - Valores originais no receptor que podem ter sido alterados

3. **Evitando acúmulo de erros**: Erros podem se acumular no processo de undo; use Memento para armazenar estado

4. **Usando templates para Commands**: Em linguagens que suportam, use templates/generics para parametrizar Command com Receiver e Action

### Técnicas

- **Macro Commands**: Composite de comandos para operações complexas
- **Histórico de Comandos**: Pilha de comandos executados para undo/redo
- **Fila de Comandos**: Fila de comandos para execução posterior
- **Comandos Transacionais**: Comandos que podem ser confirmados ou revertidos

## Usos Conhecidos

- **Frameworks GUI**: Comandos de MenuItem, ações de Button
- **Editores de Texto**: Operações de undo/redo (recortar, colar, excluir, formatar)
- **Sistemas Transacionais**: Transações de banco de dados, transações de negócio
- **Agendamento de Tarefas**: Filas de jobs, execução adiada
- **Gravação de Macros**: Gravação e reprodução de sequências de comandos
- **Comandos em Jogos**: Ações do jogador, comportamentos de IA

## Padrões Relacionados

- [**Composite**](008_composite.md): Pode implementar MacroCommands
- [**Memento**](006_memento.md): Pode manter estado para undo
- [**Prototype**](../creational/004_prototype.md): Command que deve ser copiado antes de ser colocado no histórico pode usar Prototype
- [**Chain of Responsibility**](001_chain-of-responsibility.md): Commands podem ser tratados em cadeia
- [**Strategy**](009_strategy.md): Command é um objeto que representa uma solicitação; Strategy é um objeto que representa um algoritmo

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separar invocação da execução
- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): adicionar commands sem modificar o invoker
- [038 - Command-Query Separation Principle](../../clean-code/conformidade-principio-inversao-consulta.md): command é um comando puro

---

**Criado em**: 2025-01-11
**Versão**: 1.0
