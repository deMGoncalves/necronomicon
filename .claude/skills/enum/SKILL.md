---
name: enum
description: Convenção para criação de enums eliminando strings/numbers mágicos — quando identificar strings ou números mágicos repetidos mais de uma vez, ao criar constantes de domínio ou ao revisar código com literais hardcoded em condicionais
model: haiku
allowed-tools: Write, Read, Edit, Glob, Grep
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Enum

Convenção para criação de enums eliminando strings/numbers mágicos.

---

## Quando Usar

Use quando identificar valores literais (strings ou numbers) repetidos mais de 1x.

## Condições

| Condição | Ação |
|----------|------|
| Valor repete 2+ vezes no mesmo módulo | Criar enum local |
| Valor usado por múltiplos módulos | Criar enum no módulo dono e exportar |

## Nomenclatura

| Tipo | Arquivo | Enum | Chaves |
|------|---------|------|--------|
| Seletores DOM | `element.js` | `Element` | `UPPER_SNAKE_CASE` |
| Propriedades CSS | `property.js` | `Property` | `UPPER_SNAKE_CASE` |
| Eventos | `event.js` | `Event` | `UPPER_SNAKE_CASE` |
| Status/Estados | `status.js` | `Status` | `UPPER_SNAKE_CASE` |
| Tipos/Papéis | `type.js` | `Type` | `UPPER_SNAKE_CASE` |
| Atributos | `attribute.js` | `Attribute` | `UPPER_SNAKE_CASE` |

## Regra

| Princípio | Descrição |
|-----------|-----------|
| Ownership | O módulo que define o conceito é o dono do enum |

## Estrutura de Enum

```javascript
export const Status = Object.freeze({
  PENDING: 'pending',
  ACTIVE: 'active',
  COMPLETED: 'completed',
})
```

## Exemplos

```typescript
// ❌ Ruim — magic strings e numbers
if (order.status === 'pending') { /* ... */ }
if (user.role === 'admin') { /* ... */ }
const timeout = 3000  // o que significa esse número?

// ✅ Bom — enums eliminam ambiguidade
enum OrderStatus { Pending = 'pending', Active = 'active', Cancelled = 'cancelled' }
enum UserRole { Admin = 'admin', Editor = 'editor', Viewer = 'viewer' }
const REQUEST_TIMEOUT_MS = 3000

if (order.status === OrderStatus.Pending) { /* ... */ }
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Valores literais repetidos | Criar enum quando valor aparece 2+ vezes (rule 024) |
| Enum sem Object.freeze | Violar rule 029, enum deve ser imutável |
| Enum com valores não descritivos | Usar valores que revelam intenção (rule 006) |
| Magic numbers ou magic strings | Substituir por enum nomeado (rule 024) |
| Enum em arquivo errado | Módulo dono do conceito define o enum |

## Fundamentação

- [024 - Proibição de Constantes Mágicas](../../rules/024_proibicao-constantes-magicas.md): valores literais devem ser constantes nomeadas para rastreabilidade e manutenção
- [029 - Imutabilidade de Objetos](../../rules/029_imutabilidade-objetos-freeze.md): enums devem ser congelados com Object.freeze() para prevenir modificações acidentais em runtime
- [021 - Proibição da Duplicação de Lógica](../../rules/021_proibicao-duplicacao-logica.md): valores não devem ser duplicados, centralizar em enum
