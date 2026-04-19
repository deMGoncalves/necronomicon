---
name: revelation
description: Convenção para estrutura de index de módulos — ao criar ou organizar arquivo index de um módulo — ao definir quais símbolos são públicos vs internos e estruturar re-exports
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Revelation

Convenção para estrutura de index de módulos (Module Revelation Pattern).

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Ao criar ou organizar arquivo `index.js`/`index.ts` de um módulo; ao definir quais símbolos são públicos vs internos; ao estruturar re-exports |
| **Prerequisites** | Conceito de encapsulamento e interface pública de módulo; rules 010 (SRP), 015 (REP) |
| **Constraints** | Index deve conter apenas imports e re-exports diretos — sem lógica, sem variáveis intermediárias; `export *` é proibido pois vaza detalhes de implementação |
| **Scope** | Estrutura e sintaxe do Module Revelation Pattern: `export { default }`, `export { default as Name }`, `import 'path'` com side-effect |

---

## Quando Usar

Use ao criar ou organizar exports de módulos.

## Princípio

| Princípio | Descrição |
|-----------|-----------|
| Ponto de Entrada Único | Index.js é a única interface pública do módulo |
| Simplicidade | Apenas re-exports, sem lógica adicional |

## Regras

| Regra | Descrição |
|-------|-----------|
| Apenas re-exports | Index contém apenas imports e re-exports diretos |
| Sem lógica | Código além de import/export é proibido |
| Sem variáveis | Declarar variáveis intermediárias é proibido |

## Estrutura

| Sintaxe | Uso |
|---------|-----|
| `import 'path'` | Import com side-effect |
| `export { default } from 'path'` | Re-export default como default |
| `export { default as Name } from 'path'` | Re-export default com nome |

## Exemplo

```javascript
// packages/book/button/index.js
export { default } from './button.js'
```

```javascript
// packages/book/index.js
export { default as Button } from './button/index.js'
export { default as Text } from './text/index.js'
export { default as Icon } from './icon/index.js'
```

## Exemplos

```typescript
// ❌ Ruim — expõe tudo sem controle
export * from './UserService'
export * from './UserRepository'
export * from './UserValidator'
export * from './internal/UserHelpers'  // vaza detalhes de implementação

// ✅ Bom — Revelation Pattern — expõe apenas interface pública
export { UserService } from './UserService'
export type { User, CreateUserDTO } from './types'
// UserRepository, UserHelpers são detalhes de implementação — não exportados
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Lógica no index.js | Index deve ter apenas re-exports (rule 010) |
| Variáveis intermediárias | Declarar variáveis é proibido, apenas import/export direto |
| Transformações no index | Lógica de transformação pertence aos módulos, não ao index |
| Index sem exports | Todo módulo deve expor interface clara |

## Justificativa

- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): index tem responsabilidade única de expor interface pública do módulo, sem lógica adicional
- [015 - Princípio de Equivalência de Lançamento e Reuso](../../rules/015_principio-equivalencia-lancamento-reuso.md): módulo coeso com interface clara facilita reuso em outros contextos
- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): index simples e direto é mais fácil de entender e manter
