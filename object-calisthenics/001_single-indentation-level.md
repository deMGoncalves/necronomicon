# Restrição de Nível Único de Indentação por Método

**ID**: STRUCTURAL-001
**Severity**: 🟠 High
**Category**: Structural

---

## O que é

Limita a complexidade de um método ou função ao impor um único nível de indentação para blocos de código (condicionais, *loops* ou *try-catch*), forçando a extração de lógica em métodos separados.

## Por que importa

Reduz a Complexidade Ciclomática (CC), melhorando drasticamente a legibilidade e a manutenibilidade do método, e facilitando a escrita de testes unitários focados em uma única responsabilidade.

## Critérios Objetivos

- [ ] Métodos e funções devem conter no máximo um único nível de indentação para blocos de código (após o escopo inicial do método).
- [ ] O uso de *guard clauses* para retornos antecipados não conta como um novo nível de indentação.
- [ ] Funções anônimas passadas como *callbacks* não devem introduzir um segundo nível de indentação no método pai.

## Exceções Permitidas

- **Estruturas de Controle Específicas**: *Try/Catch/Finally* em escopo de tratamento de erros que não pode ser delegado.

## Como Detectar

### Manual

Verificar a existência de blocos de código aninhados (por exemplo, um `if` dentro de um `for`, ou um `for` dentro de um `if`).

### Automático

SonarQube/ESLint: `complexity.max-depth: 1`

## Relacionado a

- [002 - Prohibition of ELSE Clause](../object-calisthenics/002_prohibition-else-clause.md): reforça
- [007 - Maximum Lines per Class Limit](../object-calisthenics/007_maximum-lines-per-class.md): complementa
- [022 - Prioritization of Simplicity and Clarity](../clean-code/priorizacao-simplicidade-clareza.md): reforça
- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): complementa
- [011 - Open/Closed Principle](002_open-closed-principle.md): reforça

---

**Criado em**: 2025-10-04
**Versão**: 1.0
