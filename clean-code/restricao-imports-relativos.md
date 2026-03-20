---
titulo: Proibição de Imports Relativos (Path Aliases Obrigatórios)
aliases:
  - Path Aliases
  - No Relative Imports
tipo: rule
id: CC-11
severidade: 🔴 Crítico
origem: clean-code
tags:
  - clean-code
  - estrutural
  - arquitetura
resolver: Antes do commit
atualizado: 2026-01-11
relacionados:
  - "[[005_dependency-inversion-principle]]"
  - "[[004_acyclic-dependencies-principle]]"
criado: 2025-10-08
---

# Proibição de Imports Relativos (Path Aliases Obrigatórios)

*Path Aliases / No Relative Imports*


---

## Definição

Proíbe **completamente** o uso de caminhos relativos com `../` e impõe o uso obrigatório de *path aliases* para todos os imports entre módulos.

## Motivação

*Imports* relativos quebram a **portabilidade** e a **legibilidade** do código. A regra reforça a **Clean Architecture**, garantindo que os módulos sejam sempre referenciados por seus aliases (`@agent`, `@dom`, `@event`, etc.), tornando o código mais consistente e fácil de refatorar.

## Quando Aplicar

- [ ] O uso de `../` em qualquer caminho de *import* é **proibido**.
- [ ] Todos os módulos devem ser importados exclusivamente por *path aliases* (ex.: `import { X } from "@dom/html"`).
- [ ] Apenas imports do mesmo diretório (`./arquivo`) são permitidos para arquivos irmãos.
- [ ] O arquivo de configuração (`vite.config.js` ou `tsconfig.json`) deve definir todos os *paths* necessários.

## Quando NÃO Aplicar

- **Arquivos Irmãos**: *Imports* diretos para arquivos no mesmo diretório (`./arquivo`) são permitidos.

## Violação — Exemplo

```javascript
// ❌ Import relativo com ../ — frágil e ilegível em projetos grandes
import { UserService } from '../../../services/user/UserService';
import { Database } from '../../../../infrastructure/db/Database';
```

## Conformidade — Exemplo

```javascript
// ✅ Path aliases — portável e autodocumentado
import { UserService } from '@services/user/UserService';
import { Database } from '@infrastructure/db/Database';

// tsconfig.json / vite.config.js:
// "@services/*": ["src/services/*"]
// "@infrastructure/*": ["src/infrastructure/*"]
```

## Anti-Patterns Relacionados

- **Relative Import Hell** — caminhos com `../../../..` que quebram ao mover arquivos

## Como Detectar

### Manual

Buscar `../` em qualquer arquivo de código-fonte.

### Automático

ESLint/Biome: Regra `no-relative-imports` configurada para proibir qualquer uso de `../`.

## Relação com ICP

Reduz **Acoplamento**: path aliases tornam dependências explícitas e gerenciáveis. Imports relativos criam acoplamento frágil à estrutura de diretórios — mover um arquivo quebra todos os importadores.

## Relacionados

- [[005_dependency-inversion-principle|Princípio da Inversão de Dependência]] — reforça
- [[004_acyclic-dependencies-principle|Princípio das Dependências Acíclicas]] — reforça
