---
titulo: Proibição de Constantes Mágicas (Magic Strings e Numbers)
aliases:
  - Magic Numbers
  - Magic Strings
tipo: rule
id: CC-04
severidade: 🔴 Crítico
origem: clean-code
tags:
  - clean-code
  - criacional
  - nomenclatura
resolver: Antes do commit
relacionados:
  - "[[003_encapsulamento-primitivos]]"
  - "[[006_prohibition-abbreviated-names]]"
  - "[[proibicao-funcoes-inseguras]]"
  - "[[003_configuracoes-via-ambiente]]"
criado: 2025-10-08
---

# Proibição de Constantes Mágicas (Magic Strings e Numbers)

*No Magic Numbers / Magic Strings*


---

## Definição

Proíbe o uso direto de valores literais (números ou strings) que possuem significado contextual ou de negócio (ex.: códigos de status, limites de tempo) em vez de constantes nomeadas ou *Value Objects*.

## Motivação

Constantes mágicas degradam a legibilidade. A alteração de um valor em múltiplos locais introduz erros graves e dificulta a manutenção, pois o contexto do valor se perde.

## Quando Aplicar

- [ ] Valores numéricos (exceto 0 e 1) usados em lógica de negócio ou condições devem ser substituídos por constantes em `UPPER_SNAKE_CASE`.
- [ ] Strings usadas para representar estados, tipos, URLs base ou *tokens* devem ser substituídas por `Enums` ou constantes.
- [ ] Constantes devem ser definidas em um módulo centralizado e importadas, nunca duplicadas.

## Quando NÃO Aplicar

- **Matemática Pura**: Valores numéricos usados em operações matemáticas básicas (ex.: `total / 2`).
- **Frameworks/Infraestrutura**: Strings exigidas por APIs de baixo nível.

## Violação — Exemplo

```javascript
// ❌ O que significa 86400? E "active"? Contexto perdido
if (user.status === 'active' && session.age < 86400) {
  grantAccess();
}
```

## Conformidade — Exemplo

```javascript
// ✅ Intenção explícita e valor centralizado
const USER_STATUS = { ACTIVE: 'active', INACTIVE: 'inactive' };
const SESSION_MAX_AGE_SECONDS = 86400; // 24 horas

if (user.status === USER_STATUS.ACTIVE && session.age < SESSION_MAX_AGE_SECONDS) {
  grantAccess();
}
```

## Anti-Patterns Relacionados

- **Magic Numbers** — literais numéricos sem contexto no meio do código
- **Magic Strings** — strings literais representando estados ou tipos de negócio

## Como Detectar

### Manual

Buscar literais `string` ou `number` dentro de `if`, `switch` ou cálculos de negócio.

### Automático

SonarQube/ESLint: `no-magic-numbers`, `no-magic-strings`.

## Relação com ICP

Não reduz diretamente o ICP, mas elimina **Acoplamento** implícito: quando um valor mágico é duplicado, múltiplos módulos ficam acoplados ao mesmo literal sem rastreabilidade.

## Relacionados

- [[003_encapsulamento-primitivos|Encapsulamento de Primitivos]] — reforça
- [[006_prohibition-abbreviated-names|Proibição de Nomes Abreviados]] — complementa
- [[proibicao-funcoes-inseguras]] — complementa
- [[003_configuracoes-via-ambiente|Configuração via Ambiente]] — complementa
