---
name: colocation
description: Arquitetura Vertical Slice para organização de src/ em 3 níveis hierárquicos (Context → Container → Component). Use ao criar novos arquivos, definir estrutura de feature ou decidir onde posicionar novo código.
model: haiku
allowed-tools: Bash, Glob, Read
metadata:
  author: deMGoncalves
  version: "2.0.0"
---

# Colocation — Arquitetura Vertical Slice

Toda implementação em `src/` segue arquitetura de vertical slice: cada feature é uma fatia vertical completa de request até banco de dados, organizada em **3 níveis hierárquicos**. Código relacionado fica junto — nunca espalhado por tipo.

→ Veja [references/vertical-slice.md](references/vertical-slice.md) para a referência completa com exemplos e guia de decisão.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Toda criação de arquivo em `src/`; decisão de onde posicionar código novo |
| **Prerequisites** | Conhecimento de domínio da feature; entendimento do modelo Context→Container→Component |
| **Constraints** | Não aplica a arquivos em `src/shared/`, `src/lib/` ou config raiz do projeto |
| **Scope** | Estrutura de diretórios em `src/`, nomeação de arquivos, separação de responsabilidades |

---

## Quando Usar

Use sempre que:
- Criar nova feature (modo Task ou Feature)
- Decidir onde posicionar um novo arquivo em `src/`
- @architect definindo caminho de implementação em `specs.md`
- @coder criando estrutura de diretórios para uma tarefa

---

## Os 3 Níveis

```
src/
└── [context]/           ← Domínio de negócio
    └── [container]/     ← Subdomínio ou serviço
        └── [component]/ ← Operação específica
            ├── controller.ts        ← Handlers HTTP + validação de entrada
            ├── service.ts           ← Lógica de negócio pura
            ├── model.ts             ← Types, interfaces, schemas
            ├── repository.ts        ← Acesso a dados (DB, APIs)
            └── [component].test.ts  ← Testes unitários e de integração
```

| Nível | O que é | Exemplos |
|-------|---------|----------|
| **Context** | Domínio de negócio de alto nível | `user`, `order`, `notification`, `payment` |
| **Container** | Subdomínio ou agrupamento funcional | `auth`, `cart`, `profile`, `inbox` |
| **Component** | Operação ou recurso específico | `login`, `checkout`, `list`, `create` |

---

## Responsabilidade de cada arquivo

| Arquivo | Responsabilidade |
|---------|------------------|
| `controller.ts` | Recebe request HTTP, valida entrada, chama service, retorna resposta |
| `service.ts` | Lógica de negócio pura — sem HTTP, sem DB direto |
| `model.ts` | Types, interfaces, schemas, DTOs |
| `repository.ts` | Acesso a dados — queries, writes, abstrações de DB/API |
| `[component].test.ts` | Testes unitários e de integração para a feature |

---

## Exemplos

### ❌ Bad — organização horizontal por tipo

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

Para trabalhar em `user/auth/login`, @coder precisa abrir 4 diretórios diferentes.

### ✅ Good — vertical slice (tudo junto verticalmente)

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

Para trabalhar em `user/auth/login`, @coder abre **um único diretório**.

---

## Proibições

| O que evitar | Razão |
|--------------|-------|
| `src/controllers/`, `src/services/` | Organização horizontal por tipo — viola coesão (rule 016) |
| `src/utils/`, `src/helpers/`, `src/common/` | Genérico sem domínio — atrai código de qualquer lugar |
| Component misturando HTTP + DB direto | Cada arquivo tem uma responsabilidade (rule 010) |
| Feature espalhada em múltiplos contexts | Se está em 2 contexts, revisar modelo de domínio |

---

## Justificativa

**Regras relacionadas:**
- [016 - Princípio do Fechamento Comum](../../rules/016_principio-fechamento-comum.md): classes que mudam juntas devem estar no mesmo pacote — reforça
- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): cada arquivo tem uma responsabilidade — reforça
- [021 - Proibição da Duplicação de Lógica](../../rules/021_proibicao-duplicacao-logica.md): vertical slice previne que a mesma lógica seja duplicada em múltiplos contexts — complementa

**Skills relacionadas:**
- [`revelation`](../revelation/SKILL.md) — complementa: index.ts de cada módulo expõe apenas a interface pública do component
- [`solid`](../solid/SKILL.md) — reforça: SRP e DIP guiam responsabilidades dentro de cada arquivo do component
