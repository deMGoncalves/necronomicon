# State

**Classificação**: Padrão Comportamental

---

## Intenção e Objetivo

Permitir que um objeto altere seu comportamento quando seu estado interno muda. O objeto parecerá ter mudado de classe. Encapsula comportamentos específicos de estado em classes separadas.

## Também Conhecido Como

- Objects for States
- State

## Motivação

Considere uma classe TCPConnection que representa uma conexão de rede. Um objeto TCPConnection pode estar em vários estados: Established, Listening, Closed. Quando um objeto TCPConnection recebe solicitações de outros objetos, ele responde de forma diferente dependendo do seu estado atual. Por exemplo, o efeito de uma solicitação Open depende de a conexão estar no estado Closed ou no estado Established.

O padrão State descreve como TCPConnection pode exibir comportamento diferente em cada estado. A ideia central é introduzir uma classe abstrata TCPState para representar os estados da conexão de rede. TCPState declara uma interface comum para todas as classes que representam diferentes estados operacionais. Subclasses de TCPState implementam comportamento específico de estado. TCPConnection mantém um objeto de estado (uma instância de uma subclasse de TCPState) que representa o estado atual, e delega todas as solicitações específicas de estado para esse objeto.

## Aplicabilidade

Use o padrão State quando:

- O comportamento de um objeto depende de seu estado, e ele deve mudar seu comportamento em tempo de execução dependendo desse estado
- Operações têm instruções condicionais grandes e multipartes que dependem do estado do objeto (tipicamente representado por constantes enum)
- Você deseja evitar lógica condicional complexa que depende de estado
- Transições de estado devem ser explícitas
- Estado compartilhado deve ser evitado

## Estrutura

```
Context
├── Mantém: State currentState
├── request()
│   └── Delega para: currentState.handle(this)
└── setState(State)
    └── Altera o estado atual

State (Interface)
└── handle(Context)

ConcreteStateA implements State
├── handle(Context)
│   ├── Executa comportamento específico do StateA
│   └── (Opcional) context.setState(new StateB())
└── Conhece: quais estados podem seguir este

ConcreteStateB implements State
├── handle(Context)
│   ├── Executa comportamento específico do StateB
│   └── (Opcional) context.setState(new StateC())
└── Conhece: quais estados podem seguir este
```

## Participantes

- **Context**: Define a interface de interesse para os clientes; mantém uma instância de uma subclasse ConcreteState que define o estado atual
- [**State**](008_state.md): Define uma interface para encapsular o comportamento associado a um estado particular do Context
- **Subclasses ConcreteState**: Cada subclasse implementa um comportamento associado a um estado do Context

## Colaborações

- Context delega solicitações específicas de estado para o objeto de estado atual
- Um context pode passar a si mesmo como argumento para o objeto State que trata a solicitação; isso permite que o objeto State acesse o context se necessário
- Context é a interface principal para os clientes; os clientes podem configurar um context com objetos State; uma vez configurado, os clientes não precisam lidar com os objetos State diretamente
- Tanto Context quanto as subclasses ConcreteState podem decidir qual estado sucede outro e sob quais circunstâncias

## Consequências

### Vantagens

- **Localiza o comportamento específico de estado**: Comportamento para diferentes estados em classes separadas
- **Torna as transições de estado explícitas**: Em vez de valores internos, as transições se tornam explícitas ao atribuir objetos State diferentes
- **Objetos State podem ser compartilhados**: Se não tiverem estado de instância, os estados podem ser Flyweights
- **Elimina condicionais complexos**: Substitui grandes condicionais por polimorfismo
- **Open/Closed**: Adicionar novos estados sem modificar os existentes

### Desvantagens

- **Aumenta o número de classes**: Cada estado requer uma nova classe
- **Sobrecarga**: Se as transições de estado são simples, pode haver sobrecarga
- **Complexidade**: Pode dificultar a compreensão do fluxo de estados

## Implementação

### Considerações

1. **Quem define as transições de estado**:
   - Classes State decidem os sucessores (mais flexibilidade, mas estados dependem uns dos outros)
   - Context decide (transições centralizadas, mas Context precisa conhecer todos os estados)

2. **Alternativa baseada em tabela**: A alternativa é manter uma tabela que mapeia entradas para transições de estado; menos flexível, mas mais compacta

3. **Criando e destruindo objetos State**:
   - Criar sob demanda e destruir depois (quando estados mudam com pouca frequência)
   - Criar todos antecipadamente (quando mudanças são frequentes; usar Flyweight)

4. **Usando estado dinâmico**: Em linguagens dinâmicas, pode-se trocar a classe de um objeto em tempo de execução

### Técnicas

- **Estados Flyweight**: Estados sem estado de instância podem ser compartilhados
- **Tabela de Transições de Estado**: Tabela definindo transições válidas
- **Máquinas de Estado Hierárquicas**: Estados compostos (subestados)
- **Pilha de Estados**: Pilha de estados para empilhar/desempilhar estados temporários

## Usos Conhecidos

- **Estados de Conexão TCP**: Established, Listening, Closed
- **Estados de Documento**: Rascunho, Moderação, Publicado
- **Estados de Pedido**: Novo, Pago, Enviado, Entregue, Cancelado
- **Estados de Personagem de Jogo**: Parado, Caminhando, Correndo, Pulando, Atacando
- **Estados de Componente UI**: Normal, Hover, Pressionado, Desabilitado
- **Mecanismos de Workflow**: Estados de processo em fluxos de trabalho de negócios

## Padrões Relacionados

- [**Flyweight**](011_flyweight.md): Explica quando e como objetos State podem ser compartilhados
- [**Singleton**](../creational/005_singleton.md): Objetos State são frequentemente Singletons
- [**Strategy**](009_strategy.md): State pode ser visto como Strategy onde a estratégia muda com base no estado; diferença: State permite que o objeto de estado mude o estado do Context
- [**Command**](002_command.md): States podem usar Commands para implementar transições
- [**Memento**](006_memento.md): Pode ser usado para salvar/restaurar estados

### Relação com Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): adicionar estados sem modificar os existentes
- [002 - Prohibition of ELSE Clause](../../object-calisthenics/002_proibicao-clausula-else.md): elimina condicionais de estado
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): cada estado uma responsabilidade

---

**Criado em**: 2025-01-11
**Versão**: 1.0
