# Interpreter

**Classificação**: Padrão Comportamental

---

## Intenção e Objetivo

Dada uma linguagem, definir uma representação para sua gramática juntamente com um interpretador que usa a representação para interpretar sentenças nessa linguagem.

## Também Conhecido Como

- Language Interpreter

## Motivação

Se um determinado tipo de problema ocorre com frequência suficiente, pode valer a pena expressar instâncias do problema como sentenças em uma linguagem simples. Você pode então construir um interpretador que resolve o problema interpretando essas sentenças. Por exemplo, buscar strings que correspondam a padrões específicos é um problema comum. Expressões regulares são uma linguagem padrão para especificar padrões de strings.

O padrão Interpreter descreve como definir uma gramática para linguagens simples, representar sentenças na linguagem e interpretar essas sentenças. No exemplo de busca, o padrão define uma máquina que realiza correspondência de padrões especificada por uma expressão regular.

## Aplicabilidade

Use o padrão Interpreter quando há uma linguagem a ser interpretada e você pode representar declarações como árvores de sintaxe abstrata. Interpreter funciona melhor quando:

- A gramática é simples; para gramáticas complexas, a hierarquia de classes se torna difícil de gerenciar
- Eficiência não é uma preocupação crítica; interpretadores mais eficientes geralmente são implementados compilando ou traduzindo sentenças para outra forma
- Você deseja executar operações em uma árvore de sintaxe abstrata (AST)
- A gramática não muda com frequência

## Estrutura

```
Client
├── Constrói: árvore sintática (AbstractExpression)
└── Invoca: interpret(context)

Context
└── Contém: informações globais para o interpretador

AbstractExpression (Interface)
└── interpret(context)

TerminalExpression implements AbstractExpression
└── interpret(context) → implementa interpretação para terminais

NonterminalExpression implements AbstractExpression
├── Compõe: List<AbstractExpression> subexpressões
└── interpret(context)
    └── Para cada subexpressão: subexpression.interpret(context)
```

## Participantes

- **AbstractExpression**: Declara uma operação Interpret abstrata comum a todos os nós da árvore de sintaxe abstrata
- **TerminalExpression**: Implementa uma operação Interpret para símbolos terminais na gramática; uma instância é necessária para cada símbolo terminal
- **NonterminalExpression**: Uma classe para cada regra da gramática; mantém instâncias de AbstractExpression para cada símbolo na regra
- **Context**: Contém informações que são globais ao interpretador; tipicamente a entrada sendo interpretada
- **Client**: Constrói (ou recebe) uma árvore de sintaxe abstrata; invoca a operação Interpret

## Colaborações

- O Client constrói (ou recebe) a sentença como uma árvore de sintaxe abstrata de instâncias das classes NonterminalExpression e TerminalExpression
- O Client inicializa o contexto e invoca a operação Interpret
- Cada nó NonterminalExpression define Interpret em termos de Interpret em cada subexpressão
- O Interpret de cada nó TerminalExpression define o caso base na recursão
- O Interpret em cada nó usa o contexto para armazenar e acessar o estado do interpretador

## Consequências

### Vantagens

- **Fácil de alterar e estender a gramática**: Como o padrão usa classes para representar regras gramaticais, você pode usar herança para alterar ou estender a gramática
- **Implementar a gramática é simples**: Classes que definem nós na árvore têm implementações similares; essas classes são fáceis de escrever
- **Adicionar novas formas de interpretar expressões**: Interpreter facilita avaliar uma expressão de uma nova forma (novo tipo de interpretador)

### Desvantagens

- **Gramáticas complexas são difíceis de manter**: Define pelo menos uma classe para cada regra; gramáticas complexas difíceis de gerenciar
- **Não é eficiente**: Usa muitas classes pequenas e muitas chamadas a métodos virtuais

## Implementação

### Considerações

1. **Criando a árvore de sintaxe abstrata**: O Client deve ter uma forma de construir a AST; pode usar um parser ou construir diretamente

2. **Definindo a operação Interpret**: Não precisa ser definida nas classes de expressão; pode usar Visitor

3. **Compartilhando símbolos terminais com Flyweight**: Gramáticas cujas sentenças contêm muitas ocorrências de um símbolo terminal podem se beneficiar do compartilhamento

### Técnicas

- **Visitor para Interpret**: Separar a interpretação da estrutura usando Visitor
- **Flyweight para Terminais**: Compartilhar objetos TerminalExpression
- [**Composite**](008_composite.md): A AST é um Composite de expressões
- **Geradores de Parser**: Usar ferramentas para gerar o parser automaticamente

## Usos Conhecidos

- **Expressões Regulares**: Correspondência de padrões em strings
- **Parsers SQL**: Interpretação e execução de consultas SQL
- **Avaliadores de Expressões**: Calculadoras, interpretadores de fórmulas
- **Linguagens de Configuração**: Interpretação de arquivos de configuração
- **Linguagens de Domínio Específico**: Interpretação de DSLs customizadas
- **Compiladores**: Front-end de compiladores (lexer, parser, AST)

## Padrões Relacionados

- [**Composite**](008_composite.md): A AST é um Composite
- [**Flyweight**](011_flyweight.md): Mostra como compartilhar símbolos terminais
- [**Iterator**](004_iterator.md): Percorrer a árvore sintática
- [**Visitor**](011_visitor.md): Usado para manter a operação Interpret em uma única classe
- [**Strategy**](009_strategy.md): O Interpreter pode ser visto como múltiplas Strategies para interpretar sentenças

### Relação com Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): adicionar expressões sem modificar as existentes
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): cada expressão uma responsabilidade
- [001 - Single Level of Indentation](../../object-calisthenics/001_nivel-unico-indentacao.md): recursão em vez de loops aninhados

---

**Criado em**: 2025-01-11
**Versão**: 1.0
