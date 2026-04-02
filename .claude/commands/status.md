---
description: "Dashboard de progresso do workflow: lista features em changes/, tasks concluídas, fase atual e counters de tentativas por agent."
allowed-tools: Read, Glob, Grep, Bash(ls *)
---

## Propósito

Exibe o estado atual de todas as features em andamento, lendo os `tasks.md` em `changes/`.

Features detectadas:
!`ls changes/ 2>/dev/null | sort || echo "(nenhuma feature em andamento)"`

Última rule adicionada:
!`ls .claude/rules/ 2>/dev/null | sort | tail -1 || echo "(regras não encontradas)"`

## Instruções

1. **Liste os diretórios** em `changes/` — se vazio, exiba orientação para usar `/start`

2. **Para cada feature**, leia `changes/XXX/tasks.md` e extraia:
   - Nome da feature (do diretório)
   - Fase atual (`**Fase Atual**` no cabeçalho)
   - Progresso: contagem de `- [x]` (concluídas) vs `- [ ]` (pendentes)
   - `<!-- attempts-developer: N -->`
   - `<!-- attempts-tester: N -->`
   - `<!-- attempts-reviewer: N -->`
   - `<!-- mode: Quick|Task|Feature -->`

3. **Exiba o dashboard** no formato:

```
══════════════════════════════════════════════
  oh my claude — Workflow Status
  Próxima rule ID disponível: [N+1 baseado em .claude/rules/]
══════════════════════════════════════════════

📋 FEATURES EM ANDAMENTO
──────────────────────────────────────────────

[001] nome-da-feature  [Feature]
  Fase:      🔬 Fase 1 — Research
  Progresso: ██░░░░░░░░  2/6 tasks (33%)
  Agente:    @architect
  Atenção:   —

[002] outra-task  [Task]
  Fase:      ⚙️  Fase 3 — Code
  Progresso: ████░░░░░░  3/6 tasks (50%)
  Tentativas: dev=2  tester=1  reviewer=0
  Atenção:   ⚠️  2 tentativas do @developer

──────────────────────────────────────────────
📊 RESUMO
  Features ativas:   N
  Tasks concluídas:  X / Y
  Progresso total:   Z%
──────────────────────────────────────────────
```

4. **Indicadores de atenção**:
   - `attempts-developer >= 3` → `⚠️ Re-spec recomendado`
   - Todos `[x]` → `✅ Completa — use /ship para commitar`
   - Nenhuma feature → orientar para `/start nome-da-feature`

5. **Ao final**, exiba o próximo ID de rule disponível:
   - Liste `.claude/rules/` e identifique o maior número existente + 1
