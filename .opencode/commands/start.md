---
description: "Inicializa uma nova Feature ou Task criando changes/00X_nome/ com templates de PRD, design, specs e tasks. Use: /start nome-da-feature"
---

## Propósito

Cria a estrutura de diretório para uma nova Feature ou Task no workflow oh my claude.
O argumento define o nome da feature: `/start user-authentication`

Features em andamento:
!`ls changes/ 2>/dev/null | sort || echo "(nenhuma ainda)"`

## Instruções

1. **Leia o argumento** `$ARGUMENTS` como nome da feature. Se vazio, peça ao usuário.

2. **Determine o próximo número** disponível em `changes/`:
   - Liste os diretórios existentes e identifique o maior número
   - Se não existir nenhum, comece em `001`
   - Incremente (zero-padded a 3 dígitos): `001`, `002`, `003`…

3. **Normalize o nome**: lowercase, espaços → hífens, sem caracteres especiais

4. **Crie** `changes/00X_nome-normalizado/` (e `changes/` se não existir)

5. **Crie os arquivos** conforme o modo:
   - **Feature** → PRD.md + design.md + specs.md + tasks.md
   - **Task** → specs.md + tasks.md apenas

6. **Conteúdo dos arquivos:**

### PRD.md (só Feature)
```markdown
# PRD — [Nome da Feature]

**Feature**: [nome]
**ID**: [00X]
**Data**: [YYYY-MM-DD]
**Status**: 🟡 Em Pesquisa

---

## Objetivo

> Descreva o problema que esta feature resolve e o valor que entrega.

## Requisitos Funcionais

- [ ] RF-01:

## Requisitos Não Funcionais

- [ ] RNF-01:

## Regras de Negócio

- RN-01:

## Critérios de Aceite

- [ ] CA-01:

## Fora do Escopo

-
```

### design.md (só Feature)
```markdown
# Design Técnico — [Nome da Feature]

**Feature**: [nome]
**ID**: [00X]

---

## Decisões Arquiteturais

| Pattern | Justificativa |
|---------|---------------|
|         |               |

## Fluxo de Dados

[Entrada] → [Processamento] → [Saída]

## Interfaces Principais

```typescript
// interfaces principais
```

## Dependências

| Módulo | Razão |
|--------|-------|
|        |       |
```

### specs.md (Feature + Task)
```markdown
# Specs — [Nome da Feature/Task]

**Feature**: [nome]
**ID**: [00X]

---

## Contexto

[1-2 linhas]

## Interfaces e Types

```typescript
// interfaces, types, schemas
```

## Contratos de API

| Método | Rota | Entrada | Saída |
|--------|------|---------|-------|
|        |      |         |       |

## Critérios de Aceite

- [ ] CA-01: caminho feliz
- [ ] CA-02: erro de validação
- [ ] CA-03: edge cases
```

### tasks.md (Feature + Task)
```markdown
# Tasks — [Nome da Feature/Task]

**Feature**: [nome]
**ID**: [00X]
**Fase Atual**: 🔬 Fase 1 — Research

---

## Progresso

| Fase | Status | Agente |
|------|--------|--------|
| 1. Research | 🟡 Pendente | @architect |
| 2. Spec | ⬜ Aguardando | @leader |
| 3. Code | ⬜ Aguardando | @developer → @tester → @reviewer |
| 4. Docs | ⬜ Aguardando | @architect |

---

## Tasks

- [ ] T-001: Criar PRD + design + specs (@architect)
- [ ] T-002: Detalhar tasks de implementação (@leader)
- [ ] T-003: Implementar código seguindo specs.md (@developer)
- [ ] T-004: Escrever e executar testes — ≥85% cobertura (@tester)
- [ ] T-005: Code review CDD + 70 rules (@reviewer)
- [ ] T-006: Sincronizar docs/ — arc42, c4, adr, bdd (@architect)

---

## Log de Iterações

| Iteração | Fase | Agente | Resultado |
|----------|------|--------|-----------|
| #1       |      |        |           |

<!-- mode: Feature -->
<!-- attempts-developer: 0 -->
<!-- attempts-tester: 0 -->
<!-- attempts-reviewer: 0 -->
```

7. **Exiba o resultado**:
   ```
   ✅ Feature inicializada: changes/00X_nome/
   Próximo passo: @leader, inicie o workflow para changes/00X_nome/
   ```
