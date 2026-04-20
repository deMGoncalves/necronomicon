---
description: "Dashboard de progresso do fluxo: lista features em changes/, tarefas completas, fase atual e contadores de tentativas por agente."
allowed-tools: Read, Glob, Grep, Bash(ls *)
---

## Propósito

Exibe estado atual de todos os features em andamento, lendo `tasks.md` em `changes/`.

Features detectados:
!`ls changes/ 2>/dev/null | sort || echo "(nenhum feature em andamento)"`

Última regra adicionada:
!`ls .claude/rules/ 2>/dev/null | sort | tail -1 || echo "(regras não encontradas)"`

## Instruções

1. **Listar diretórios** em `changes/` — se vazio, mostrar orientação para usar `/start`

2. **Para cada feature**, ler `changes/XXX/tasks.md` e extrair:
   - Nome do feature (do diretório)
   - Fase atual (`**Fase Atual**` no cabeçalho)
   - Progresso: contagem de `- [x]` (completo) vs `- [ ]` (pendente)
   - `<!-- attempts-coder: N -->`
   - `<!-- attempts-tester: N -->`
   - `<!-- mode: Quick|Task|Feature -->`

3. **Exibir dashboard** no formato:

```
══════════════════════════════════════════════
  oh my claude — Status do Fluxo
  Próximo ID de regra disponível: [N+1 baseado em .claude/rules/]
══════════════════════════════════════════════

📋 FEATURES EM ANDAMENTO
──────────────────────────────────────────────

[001] nome-feature  [Feature]
  Fase:      🔬 Fase 1 — Pesquisa
  Progresso: ██░░░░░░░░  2/6 tarefas (33%)
  Agente:    @architect
  Atenção:   —

[002] outra-task  [Task]
  Fase:      ⚙️  Fase 3 — Code
  Progresso: ████░░░░░░  3/6 tarefas (50%)
  Tentativas: coder=2  tester=1
  Atenção:   ⚠️  2 tentativas @coder

──────────────────────────────────────────────
📊 RESUMO
  Features ativos:   N
  Tarefas completas: X / Y
  Progresso total:   Z%
──────────────────────────────────────────────
```

4. **Indicadores de atenção**:
   - `attempts-coder >= 3` → `⚠️ Re-spec recomendado`
   - Todos `[x]` → `✅ Completo — use /ship para commit`
   - Sem features → orientar para `/start nome-feature`

5. **Ao final**, exibir próximo ID de regra disponível:
   - Listar `.claude/rules/` e identificar número mais alto existente + 1
