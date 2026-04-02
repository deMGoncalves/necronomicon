---
name: colocation
description: Arquitetura Vertical Slice para organização de src/ em 3 níveis hierárquicos (Context → Container → Component). Use ao criar novos arquivos, definir estrutura de feature ou decidir onde posicionar código novo.
model: haiku
allowed-tools: Bash, Glob, Read
metadata:
  author: deMGoncalves
  version: "2.0.0"
---

# Colocation — Vertical Slice Architecture

Toda implementação em `src/` segue uma arquitetura vertical slice: cada feature é um corte vertical completo da requisição ao banco, organizada em **3 níveis hierárquicos**. Código relacionado fica junto — nunca espalhado por tipo.

→ Consulte [references/vertical-slice.md](references/vertical-slice.md) para a referência completa com exemplos e guia de decisão.

---

## Quando Usar

Use sempre que:
- Criar nova feature (Task ou Feature mode)
- Decidir onde posicionar um arquivo novo em `src/`
- @architect definir o path da implementação em `specs.md`
- @developer criar a estrutura de diretórios para uma task

---

## Os 3 Níveis

```
src/
└── [context]/           ← Domínio de negócio
    └── [container]/     ← Subdomínio ou serviço
        └── [component]/ ← Operação específica
            ├── controller.ts        ← HTTP handlers + validação de input
            ├── service.ts           ← Business logic pura
            ├── model.ts             ← Types, interfaces, schemas
            ├── repository.ts        ← Acesso a dados (DB, APIs)
            └── [component].test.ts  ← Testes unitários e integração
```

| Nível | O que é | Exemplos |
|-------|---------|---------|
| **Context** | Domínio de negócio de alto nível | `user`, `order`, `notification`, `payment` |
| **Container** | Subdomínio ou agrupamento funcional | `auth`, `cart`, `profile`, `inbox` |
| **Component** | Operação ou recurso específico | `login`, `checkout`, `list`, `create` |

---

## Responsabilidade de cada arquivo

| Arquivo | Responsabilidade |
|---------|-----------------|
| `controller.ts` | Recebe HTTP request, valida input, chama service, retorna response |
| `service.ts` | Business logic pura — sem HTTP, sem DB direto |
| `model.ts` | Types, interfaces, schemas, DTOs |
| `repository.ts` | Acesso a dados — queries, writes, abstrações de DB/API |
| `[component].test.ts` | Testes unitários e de integração da feature |

---

## Exemplos

### ❌ Ruim — organização horizontal por tipo

```
src/
├── controllers/
│   ├── user.controller.ts
│   └── order.controller.ts
├── services/
│   ├── user.service.ts
│   └── order.service.ts
├── models/
│   ├── user.model.ts
│   └── order.model.ts
└── repositories/
    ├── user.repository.ts
    └── order.repository.ts
```

Para trabalhar em `user/auth/login`, o @developer precisa abrir 4 diretórios diferentes.

### ✅ Bom — vertical slice (tudo junto na vertical)

```
src/
├── user/                    ← Context
│   ├── auth/                ← Container
│   │   ├── login/           ← Component
│   │   │   ├── controller.ts
│   │   │   ├── service.ts
│   │   │   ├── model.ts
│   │   │   ├── repository.ts
│   │   │   └── login.test.ts
│   │   └── register/
│   │       └── [mesmos arquivos]
│   └── profile/
│       └── update/
│
└── order/                   ← Context
    └── cart/                ← Container
        ├── add-item/        ← Component
        └── checkout/
```

Para trabalhar em `user/auth/login`, o @developer abre **um único diretório**.

---

## Proibições

| O que evitar | Razão |
|--------------|-------|
| `src/controllers/`, `src/services/` | Organização horizontal por tipo — viola coesão (rule 016) |
| `src/utils/`, `src/helpers/`, `src/common/` | Genérico sem domínio — atrai código de qualquer lugar |
| Componente misturando HTTP + DB direto | Cada arquivo tem uma responsabilidade (rule 010) |
| Feature espalhada por múltiplos contextos | Se está em 2 contextos, reveja o modelo de domínio |

---

## Fundamentação

**Rules relacionadas:**
- [016 - Princípio do Fechamento Comum](../../rules/016_principio-fechamento-comum.md): classes que mudam juntas devem estar no mesmo pacote — reforça
- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): cada arquivo tem uma responsabilidade — reforça
- [021 - Proibição da Duplicação de Lógica](../../rules/021_proibicao-duplicacao-logica.md): vertical slice evita que a mesma lógica seja duplicada em múltiplos contextos — complementa

**Skills relacionadas:**
- [`revelation`](../revelation/SKILL.md) — complementa: index.ts de cada módulo expõe apenas a interface pública do component
- [`solid`](../solid/SKILL.md) — reforça: SRP e DIP guiam as responsabilidades dentro de cada arquivo do component
