# Vertical Slice — Referência Completa

## Estrutura de src/ para projeto real

```
src/
│
├── user/                         ← Context: domínio "usuário"
│   ├── auth/                     ← Container: autenticação
│   │   ├── login/                ← Component
│   │   │   ├── controller.ts
│   │   │   ├── service.ts
│   │   │   ├── model.ts
│   │   │   ├── repository.ts
│   │   │   └── login.test.ts
│   │   ├── register/
│   │   │   ├── controller.ts
│   │   │   ├── service.ts
│   │   │   ├── model.ts
│   │   │   ├── repository.ts
│   │   │   └── register.test.ts
│   │   └── refresh/
│   │       └── [mesmos arquivos]
│   │
│   └── profile/                  ← Container: perfil do usuário
│       ├── update/
│       └── avatar/
│
├── order/                        ← Context: domínio "pedido"
│   ├── cart/                     ← Container: carrinho
│   │   ├── add-item/
│   │   ├── remove-item/
│   │   └── checkout/
│   │
│   └── history/                  ← Container: histórico
│       └── list/
│
└── notification/                 ← Context: domínio "notificação"
    └── in-app/                   ← Container
        ├── list/
        └── mark-read/
```

---

## Guia de decisão

### Quando criar um novo Context?

Crie um novo Context quando representar um **domínio de negócio independente** — algo que poderia ser um microserviço separado.

| Situação | Decisão |
|----------|---------|
| É um domínio de negócio diferente? | Novo Context |
| Compartilha entidades com outro contexto? | Avaliar: subdomínio ou contexto separado |
| É uma feature de um domínio existente? | Container dentro do Context existente |

### Quando criar um novo Container?

Crie um Container para **agrupar operações relacionadas** dentro de um Context.

| Situação | Decisão |
|----------|---------|
| Conjunto de operações CRUD de uma entidade | Container (ex: `profile/`) |
| Funcionalidade específica com múltiplos endpoints | Container (ex: `auth/`) |
| Processo de negócio com steps sequenciais | Container (ex: `checkout/`) |

### Quando criar um novo Component?

Cada Component representa **uma operação específica** — tipicamente um endpoint HTTP ou um use case.

| Operação | Component |
|----------|-----------|
| POST /users/auth/login | `user/auth/login/` |
| GET /orders/cart | `order/cart/list/` |
| PUT /users/profile/avatar | `user/profile/avatar/` |

---

## Regras de nomenclatura

| Nível | Formato | Exemplos |
|-------|---------|---------|
| Context | `kebab-case` singular | `user`, `order`, `notification` |
| Container | `kebab-case` singular ou verbo | `auth`, `cart`, `profile`, `in-app` |
| Component | `kebab-case` verbo ou substantivo da ação | `login`, `checkout`, `add-item`, `list` |
| Arquivo de teste | `[component].test.ts` | `login.test.ts`, `checkout.test.ts` |

---

## Como uma Feature mapeia para o path

Ao receber uma feature request como *"implementar login com JWT"*:

1. **Context**: `user` — domínio de usuário
2. **Container**: `auth` — autenticação
3. **Component**: `login` — operação específica de login
4. **Path**: `src/user/auth/login/`
5. **Arquivos**:
   - `controller.ts` — POST /auth/login
   - `service.ts` — validação + geração de JWT
   - `model.ts` — LoginRequest, LoginResponse, JwtPayload
   - `repository.ts` — busca de usuário no DB
   - `login.test.ts` — testes da feature

---

## Benefícios para o workflow oh my claude

| Benefício | Como se manifesta |
|-----------|------------------|
| **LLM efficiency** | @developer lê apenas `src/user/auth/login/` — não precisa processar todo o src/ |
| **Task isolation** | Cada Task tem um path único — zero conflito entre tasks paralelas |
| **Git hygiene** | Uma feature = um diretório = PR limpo sem diffs espalhados |
| **Test coverage** | Cada component tem seu `.test.ts` co-located — fácil de medir cobertura |
| **Onboarding** | Novo dev encontra tudo em um lugar — sem "onde fica X?" |
