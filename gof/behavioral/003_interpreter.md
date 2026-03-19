# Interpreter

**Classification**: Behavioral Pattern

---

## Intent and Purpose

Given a language, define a representation for its grammar along with an interpreter that uses the representation to interpret sentences in the language.

## Also Known As

- Language Interpreter

## Motivation

If a particular type of problem occurs frequently enough, it may be worth expressing instances of the problem as sentences in a simple language. Then you can build an interpreter that solves the problem by interpreting these sentences. For example, searching for strings matching specific patterns is a common problem. Regular expressions are a standard language for specifying string patterns.

The Interpreter pattern describes how to define a grammar for simple languages, represent sentences in the language, and interpret those sentences. In the search example, the pattern defines a machine that performs pattern matching specified by a regular expression.

## Applicability

Use the Interpreter pattern when there's a language to interpret and you can represent statements as abstract syntax trees. Interpreter works best when:

- The grammar is simple; for complex grammars, the class hierarchy becomes difficult to manage
- Efficiency is not a critical concern; more efficient interpreters are usually implemented by compiling or translating sentences into another form
- You want to execute operations on an abstract syntax tree (AST)
- The grammar doesn't change frequently

## Structure

```
Client
├── Constructs: syntax tree (AbstractExpression)
└── Invokes: interpret(context)

Context
└── Contains: global information to the interpreter

AbstractExpression (Interface)
└── interpret(context)

TerminalExpression implements AbstractExpression
└── interpret(context) → implements interpretation for terminals

NonterminalExpression implements AbstractExpression
├── Composes: List<AbstractExpression> subexpressions
└── interpret(context)
    └── For each subexpression: subexpression.interpret(context)
```

## Participants

- **AbstractExpression**: Declares an abstract Interpret operation common to all nodes in the abstract syntax tree
- **TerminalExpression**: Implements an Interpret operation for terminal symbols in the grammar; an instance is required for every terminal symbol
- **NonterminalExpression**: One class for each rule in the grammar; maintains AbstractExpression instances for each symbol in the rule
- **Context**: Contains information that's global to the interpreter; typically the input being interpreted
- **Client**: Builds (or is given) an abstract syntax tree; invokes the Interpret operation

## Collaborations

- Client builds (or is given) the sentence as an abstract syntax tree of instances of NonterminalExpression and TerminalExpression classes
- Client initializes the context and invokes the Interpret operation
- Each NonterminalExpression node defines Interpret in terms of Interpret on each subexpression
- The Interpret of each TerminalExpression node defines the base case in the recursion
- The Interpret at each node uses the context to store and access the interpreter's state

## Consequences

### Advantages

- **Easy to change and extend grammar**: Because the pattern uses classes to represent grammar rules, you can use inheritance to change or extend the grammar
- **Implementing the grammar is easy**: Classes defining nodes in the tree have similar implementations; these classes are easy to write
- **Adding new ways to interpret expressions**: Interpreter makes it easy to evaluate an expression in a new way (new interpreter type)

### Disadvantages

- **Complex grammars are hard to maintain**: Defines at least one class for each rule; complex grammars difficult to manage
- **Not efficient**: Uses many small classes and many virtual method calls

## Implementation

### Considerations

1. **Creating the abstract syntax tree**: Client must have a way to build the AST; can use a parser or build directly

2. **Defining the Interpret operation**: Doesn't need to be defined in expression classes; can use Visitor

3. **Sharing terminal symbols with Flyweight**: Grammars whose sentences contain many occurrences of a terminal symbol can benefit from sharing

### Techniques

- **Visitor for Interpret**: Separate interpretation from structure using Visitor
- **Flyweight for Terminals**: Share TerminalExpression objects
- [**Composite**](008_composite.md): AST is Composite of expressions
- **Parser Generators**: Use tools to generate parser automatically

## Known Uses

- **Regular Expressions**: Pattern matching in strings
- **SQL Parsers**: Interpret and execute SQL queries
- **Expression Evaluators**: Calculators, formula interpreters
- **Configuration Languages**: Interpret configuration files
- **Domain Specific Languages**: Interpret custom DSLs
- **Compilers**: Compiler front-end (lexer, parser, AST)

## Related Patterns

- [**Composite**](008_composite.md): AST is Composite
- [**Flyweight**](011_flyweight.md): Shows how to share terminal symbols
- [**Iterator**](004_iterator.md): Traverse syntax tree
- [**Visitor**](011_visitor.md): Used to maintain Interpret operation in one class
- [**Strategy**](009_strategy.md): Interpreter can be seen as multiple Strategies for interpreting sentences

### Relation to Rules

- [011 - Open/Closed Principle](../../solid/002_open-closed-principle.md): add expressions without modifying existing
- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): each expression one responsibility
- [001 - Single Level of Indentation](../../object-calisthenics/001_nivel-unico-indentacao.md): recursion instead of nested loops

---

**Created on**: 2025-01-11
**Version**: 1.0
