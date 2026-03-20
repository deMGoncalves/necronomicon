# Conformidade com o Liskov Substitution Principle (LSP)

**ID**: BEHAVIORAL-012
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## O que é

Exige que classes derivadas (subclasses) sejam substituíveis por suas classes base (superclasses) sem alterar o comportamento esperado do programa.

## Por que importa

A violação do LSP quebra a coesão do sistema de tipos e o contrato de herança, forçando os clientes a verificar o tipo do objeto, o que leva à violação do OCP e introduz bugs sérios em tempo de execução.

## Critérios Objetivos

- [ ] Subclasses não devem lançar exceções que não sejam lançadas pela classe base (comportamento).
- [ ] Subclasses não devem enfraquecer pré-condições nem fortalecer pós-condições da classe base (assinatura/contrato).
- [ ] O uso de verificações de tipo (`instanceof` ou *type guards* complexos) em código cliente que usa a interface da classe base é proibido.

## Exceções Permitidas

- **Frameworks de Teste**: Uso de *mocks* e *spies* em testes unitários para simular comportamentos de substituição de forma controlada.

## Como Detectar

### Manual

Buscar por `if (object instanceof Subclass)` ou uso de um método da classe base que lança `UnsupportedOperationException`.

### Automático

TypeScript/Compilador: Verificação estrita de tipagem de parâmetros e retornos de métodos sobrescritos.

## Relacionado a

- [011 - Open/Closed Principle](../solid/002_open-closed-principle.md): reforça
- [009 - Tell, Don't Ask](../object-calisthenics/009_tell-dont-ask.md): reforça
- [003 - Primitive Encapsulation](../object-calisthenics/003_primitive-encapsulation.md): complementa
- [013 - Interface Segregation Principle](../solid/004_interface-segregation-principle.md): reforça
- [036 - Side Effect Function Restriction](../clean-code/restricao-funcoes-efeitos-colaterais.md): reforça

---

**Criado em**: 2025-10-04
**Versão**: 1.0
