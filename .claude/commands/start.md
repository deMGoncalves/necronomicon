---
description: "Inicializa novo Feature ou Task criando changes/00X_name/ com templates de PRD, design, specs e tasks. Uso: /start nome-feature"
argument-hint: "[nome-feature]"
allowed-tools: Read, Write, Glob, Bash(ls *)
---

## Propósito

Cria estrutura de diretórios para novo Feature ou Task no fluxo do oh my claude.
Argumento define nome da feature: `/start autenticacao-usuario`

Features em andamento:
!`ls changes/ 2>/dev/null | sort || echo "(nenhuma ainda)"`

## Instruções

1. **Ler argumento** `$ARGUMENTS` como nome da feature. Se vazio, perguntar ao usuário.

2. **Determinar próximo número disponível** em `changes/`:
   - Listar diretórios existentes e identificar número mais alto
   - Se não existir nenhum, iniciar em `001`
   - Incrementar (zero-padded para 3 dígitos): `001`, `002`, `003`…

3. **Normalizar nome**: minúsculas, espaços → hífens, sem caracteres especiais

4. **Criar** `changes/00X_nome-normalizado/` (e `changes/` se não existir)

5. **Criar arquivos** conforme modo:
   - **Feature** → PRD.md + design.md + specs.md + tasks.md
   - **Task** → specs.md + tasks.md apenas

6. **Conteúdo dos arquivos:**

### PRD.md (Feature apenas)
```markdown
# PRD — [Nome do Feature]

**Feature**: [nome]
**ID**: [00X]
**Data**: [AAAA-MM-DD]
**Status**: 🟡 Em Pesquisa

---

## Objetivo

> Descrever o problema que este feature resolve e o valor que entrega.

## Requisitos Funcionais

- [ ] RF-01:

## Requisitos Não-Funcionais

- [ ] RNF-01:

## Regras de Negócio

- RN-01:

## Critérios de Aceitação

- [ ] CA-01:

## Fora de Escopo

-
```

### design.md (Feature apenas)
```markdown
# Design Técnico — [Nome do Feature]

**Feature**: [nome]
**ID**: [00X]

---

## Decisões Arquiteturais

| Padrão | Justificativa |
|--------|---------------|
|        |               |

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
# Specs — [Nome do Feature/Task]

**Feature**: [nome]
**ID**: [00X]

---

## Contexto

[1-2 linhas]

## Interfaces e Tipos

```typescript
// interfaces, types, schemas
```

## Contratos de API

| Método | Rota | Entrada | Saída |
|--------|------|---------|-------|
|        |      |         |       |

## Critérios de Aceitação

- [ ] CA-01: caminho feliz
- [ ] CA-02: erro de validação
- [ ] CA-03: casos extremos
```

### tasks.md (Feature + Task)
```markdown
# Tasks — [Nome do Feature/Task]

**Feature**: [nome]
**ID**: [00X]
**Fase Atual**: 🔬 Fase 1 — Pesquisa

---

## Progresso

| Fase | Status | Agente |
|------|--------|--------|
| 1. Plan | 🟡 Pendente | @planner → @architect |
| 2. Spec | ⬜ Aguardando | @architect |
| 3. Code | ⬜ Aguardando | @coder → @tester → @architect review |
| 4. Docs | ⬜ Aguardando | @architect |

---

## Tarefas

- [ ] T-000: Planejar + criar estrutura de tasks (@planner)
- [ ] T-001: Criar PRD + design + specs (@architect)
- [ ] T-002: Detalhar tarefas de implementação (Tech Lead)
- [ ] T-003: Implementar código seguindo specs.md (@coder)
- [ ] T-004: Escrever e rodar testes — cobertura ≥85% (@tester)
- [ ] T-005: Revisão arquitetural CDD/ICP + 70 regras (@architect review)
- [ ] T-006: Sincronizar docs/ — arc42, c4, adr, bdd (@architect)

---

## Log de Iterações

| Iteração | Fase | Agente | Resultado |
|----------|------|--------|-----------|
| #1       |      |        |           |

<!-- mode: Feature -->
<!-- attempts-coder: 0 -->
<!-- attempts-tester: 0 -->
```

7. **Exibir resultado**:
   ```
   ✅ Feature inicializado: changes/00X_nome/
   Próximo passo: iniciar fluxo para changes/00X_nome/
   ```
