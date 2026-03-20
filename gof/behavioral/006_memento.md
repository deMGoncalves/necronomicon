# Memento

**Classificação**: Padrão Comportamental

---

## Intenção e Objetivo

Sem violar o encapsulamento, capturar e externalizar o estado interno de um objeto para que o objeto possa ser restaurado a esse estado mais tarde. Permite implementar undo/redo, snapshots e checkpoints mantendo o encapsulamento.

## Também Conhecido Como

- Token
- Snapshot

## Motivação

Às vezes é necessário registrar o estado interno de um objeto para implementar checkpoints e mecanismos de desfazer. Os objetos normalmente encapsulam parte ou todo o seu estado, tornando-o inacessível a outros objetos e impossível de salvar externamente. Expor esse estado violaria o encapsulamento, o que pode comprometer a robustez e a extensibilidade da aplicação.

Considere um editor gráfico que suporta conectividade entre objetos. Um usuário pode alinhar objetos conectando-os. O alinhamento pode modificar estruturas de dados que especificam a conectividade. Implementar undo requer armazenar as estruturas de dados que especificam exatamente como os objetos estão conectados. Mas os objetos Constraint encapsulam essas estruturas internamente.

O padrão Memento resolve esse problema sem comprometer o encapsulamento. O Originator (Constraint) delega o salvamento do estado para outro objeto (memento). Apenas o originator pode armazenar e recuperar informações do memento.

## Aplicabilidade

Use o padrão Memento quando:

- Um snapshot de (alguma parte do) estado de um objeto deve ser salvo para que possa ser restaurado posteriormente
- Uma interface direta para obter o estado exporia detalhes de implementação e quebraria o encapsulamento do objeto
- Você precisa implementar undo/redo
- Você deseja implementar transações que possam ser revertidas
- Você precisa implementar checkpoints em processos de longa duração

## Estrutura

```
Originator
├── Mantém: estado interno
├── createMemento(): Memento
│   └── return new Memento(state)
└── restore(memento: Memento)
    └── state = memento.getState()

Memento
├── Mantém: estado salvo do Originator
├── getState() → retorna estado (apenas para Originator)
└── (Opcionalmente) interface limitada para Caretaker

Caretaker
├── Mantém: List<Memento> (histórico)
├── Responsável por: salvar e restaurar o Originator
├── saveState()
│   └── history.add(originator.createMemento())
└── undo()
    └── originator.restore(history.pop())
```

## Participantes

- [**Memento**](006_memento.md): Armazena o snapshot do estado interno do Originator; protege contra acesso de objetos que não sejam o originator
- **Originator**: Cria o memento contendo o snapshot de seu estado interno atual; usa o memento para restaurar seu estado interno
- **Caretaker**: Responsável pela guarda do memento; nunca opera nem examina o conteúdo de um memento

## Colaborações

- Caretaker solicita um memento ao originator, mantém-o por um tempo e o passa de volta ao originator
- Mementos são passivos; apenas o originator que criou um memento irá atribuir ou recuperar seu estado

## Consequências

### Vantagens

- **Preserva o encapsulamento**: Evita expor informações que apenas um originator deve gerenciar mas que precisam ser armazenadas fora dele
- **Simplifica o Originator**: O originator não precisa gerenciar versões do estado interno
- **Permite undo/redo**: O histórico de mementos permite navegar entre estados
- **Separação de responsabilidades**: Caretaker gerencia quando e por que capturar o estado

### Desvantagens

- **Custo de cópia do estado**: Pode ser caro se o Originator precisar copiar grandes quantidades de informação
- **Custos do Caretaker**: O Caretaker pode incorrer em custos significativos de armazenamento
- **Sobrecarga de memória**: Manter muitos mementos pode consumir muita memória

## Implementação

### Considerações

1. **Suporte da linguagem para preservar o encapsulamento**: Idealmente, apenas o Originator pode acessar o estado do memento

2. **Armazenando mudanças incrementais**: Se criar e restaurar estado for caro, os mementos podem armazenar apenas as mudanças incrementais

3. **Restauração preguiçosa**: Adiar a restauração até que seja realmente necessária

4. **Limitando o histórico**: Limitar o número de mementos para controlar o uso de memória (cache LRU)

### Técnicas

- **Memento Incremental**: Armazenar apenas as diferenças desde o último snapshot
- **Compressão de Mementos**: Comprimir o estado para economizar memória
- **Copy-on-write**: Compartilhar estado até a modificação
- **Prototype para clonagem**: Usar Prototype para copiar o estado
- **Serialização**: Serializar o estado do objeto

## Usos Conhecidos

- **Editores de Texto**: Undo/redo de edições (Ctrl+Z, Ctrl+Y)
- **Transações de Banco de Dados**: Savepoints e rollback
- **Estado de Jogo**: Jogos salvos, checkpoints
- **Editores Gráficos**: Operações de undo (Photoshop, GIMP)
- **Controle de Versão**: Snapshots do estado do projeto
- **Histórico do Navegador**: Navegação para trás/frente

## Padrões Relacionados

- [**Command**](002_command.md): Commands podem usar Mementos para manter estado para undo
- [**Iterator**](004_iterator.md): Memento pode ser usado para capturar o estado da iteração
- [**Prototype**](../creational/004_prototype.md): Mementos podem usar Prototype para copiar estado
- [**State**](008_state.md): Memento pode salvar estados do padrão State
- **Serialização**: Técnica comum para implementar Memento

### Relação com Rules

- [029 - Object Immutability](../../clean-code/imutabilidade-objetos-freeze.md): mementos devem ser imutáveis
- [036 - Function Side Effects Restriction](../../clean-code/restricao-funcoes-efeitos-colaterais.md): restauração não deve ter efeitos colaterais
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separar gerenciamento de estado

---

**Criado em**: 2025-01-11
**Versão**: 1.0
