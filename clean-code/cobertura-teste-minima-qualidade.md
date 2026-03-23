---
titulo: Cobertura Mínima de Testes e Qualidade (TDD)
aliases:
  - TDD — Test-Driven Development
  - Test Coverage
tipo: rule
id: CC-12
severidade: 🔴 Crítico
origem: clean-code
tags:
  - clean-code
  - comportamental
  - testes
  - tdd
resolver: Antes do commit
relacionados:
  - "[[002_open-closed-principle]]"
  - "[[001_single-responsibility-principle]]"
  - "[[005_dependency-inversion-principle]]"
  - "[[010_paridade-dev-prod]]"
criado: 2025-10-08
---

# Cobertura Mínima de Testes e Qualidade (TDD)

*TDD — Test-Driven Development*


---

## Definição

Estabelece um limite mínimo obrigatório de **Cobertura de Código** para o Módulo de Domínio/Negócio (Use Cases e Entities) e exige que os testes unitários sigam o princípio AAA (*Arrange, Act, Assert*).

## Motivação

Garante **confiabilidade** e facilita a refatoração. Código sem testes unitários de alta qualidade é frágil e viola o OCP (Princípio Aberto/Fechado).

## Quando Aplicar

- [ ] A Cobertura de Linhas dos testes deve ser de pelo menos **85%** para todos os módulos de domínio/negócio.
- [ ] É proibido o uso de lógica de controle (ex.: `if`, `for`, `while`) diretamente dentro do corpo de um teste unitário.
- [ ] Cada teste unitário deve focar em uma única asserção (máximo 2) e seguir a estrutura AAA (Arrange, Act, Assert).

## Quando NÃO Aplicar

- **Módulos de Inicialização**: Arquivos de configuração e *root composers* (que não contêm lógica de negócio) podem ter cobertura baixa ou zero.

## Violação — Exemplo

```javascript
// ❌ Lógica de controle dentro do teste — não testa um cenário específico
test('processPayment deve funcionar', () => {
  const orders = getTestOrders();
  for (const order of orders) { // loop no teste = múltiplos cenários misturados
    if (order.type === 'premium') {
      expect(processPayment(order)).toBe(true);
    }
  }
});
```

## Conformidade — Exemplo

```javascript
// ✅ Estrutura AAA, cenário único, sem lógica de controle
test('processPayment deve retornar true para pedido premium pago', () => {
  // Arrange
  const order = createPremiumOrder({ isPaid: true });

  // Act
  const result = processPayment(order);

  // Assert
  expect(result).toBe(true);
});
```

## Anti-Patterns Relacionados

- **Test Logic** — lógica condicional ou loops dentro de testes
- **God Test** — um único teste que verifica múltiplos comportamentos

## Como Detectar

### Manual

Buscar `if` ou `for` dentro de blocos `test()` ou `it()`.

### Automático

Bun Test Runner/Jest: Configuração de `coverageThresholds`.

## Relação com ICP

Impacto indireto: código testável exige naturalmente **[[componente-cc-base|CC_base]]** baixo e **[[componente-responsabilidades|Responsabilidades]]** únicas por função. Se um método é difícil de testar, seu [[calculo-icp|ICP]] provavelmente está elevado.

## Relacionados

- [[002_open-closed-principle|Princípio Aberto/Fechado]] — reforça
- [[001_single-responsibility-principle|Princípio da Responsabilidade Única]] — reforça
- [[005_dependency-inversion-principle|Princípio da Inversão de Dependência]] — complementa
- [[010_paridade-dev-prod|Paridade Dev/Prod]] — complementa
