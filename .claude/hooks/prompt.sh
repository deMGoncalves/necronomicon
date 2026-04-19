#!/bin/bash
# =============================================================================
# Hook: prompt.sh
# Evento: UserPromptSubmit (sem matcher)
# Objetivo: Injetar contexto de roteamento + estado de sessão ativa (bootstrap)
# Entrada: JSON via stdin com prompt, cwd, session_id
# =============================================================================

INPUT=$(cat)

PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

if [ -z "$PROMPT" ]; then
  exit 0
fi

# -----------------------------------------------------------------------------
# PASSO 1: Bootstrap — detectar sessão ativa com trabalho em andamento
# -----------------------------------------------------------------------------
BOOTSTRAP_HINT=""
ACTIVE_TASKS=$(find "${CWD}/changes" -name "tasks.md" -maxdepth 2 2>/dev/null | \
  xargs grep -l "^\s*- \[ \]" 2>/dev/null | sort | head -1)

FEATURE=""
if [ -n "$ACTIVE_TASKS" ]; then
  FEATURE=$(echo "$ACTIVE_TASKS" | sed "s|${CWD}/changes/||" | sed "s|/tasks.md||")
  PENDING_COUNT=$(grep -cE "^\s*- \[ \]" "$ACTIVE_TASKS" 2>/dev/null || echo "?")
  CODER_ATT=$(grep -oE "attempts-coder: [0-9]+" "$ACTIVE_TASKS" 2>/dev/null | grep -oE "[0-9]+" || echo "0")
  BOOTSTRAP_HINT="[SESSÃO ATIVA] Feature: changes/${FEATURE}/ | Pendentes: ${PENDING_COUNT} tarefas | @coder tentativas: ${CODER_ATT}/3. Verificar tasks.md e perguntar ao usuário se deseja continuar antes de iniciar novo trabalho. "
fi

# -----------------------------------------------------------------------------
# PASSO 2: Exclusões — perguntas conceituais não devem acionar roteamento
# -----------------------------------------------------------------------------
if echo "$PROMPT" | grep -qiE \
  '^(how (does|do|is|are)|what (is|are|does)|which (is|are)|why (is|are|does)|when (to use|should)|where (is|does|goes)|explain|tell me what|understand|help me understand|can you explain|what.s the difference)'; then
  # Ainda injetar bootstrap se houver sessão ativa
  if [ -n "$BOOTSTRAP_HINT" ]; then
    jq -n --arg hint "$BOOTSTRAP_HINT" '{
      "hookSpecificOutput": {
        "hookEventName": "UserPromptSubmit",
        "additionalSystemPrompt": $hint
      }
    }'
  fi
  exit 0
fi

# Prompts terminando com "?" sem verbos imperativos claros são perguntas
if echo "$PROMPT" | grep -qE '\?$' && \
   ! echo "$PROMPT" | grep -qiE \
     '(implement|create|add|fix|refactor|develop|build|write|generate|configure|migrate|update|delete|remove)'; then
  if [ -n "$BOOTSTRAP_HINT" ]; then
    jq -n --arg hint "$BOOTSTRAP_HINT" '{
      "hookSpecificOutput": {
        "hookEventName": "UserPromptSubmit",
        "additionalSystemPrompt": $hint
      }
    }'
  fi
  exit 0
fi

# -----------------------------------------------------------------------------
# PASSO 3: Inclusões — verbos imperativos e palavras de ação claras
# -----------------------------------------------------------------------------
if echo "$PROMPT" | grep -qiE \
  '(implement|create|build|add|fix|refactor|develop|new feature|feature|new task|endpoint|write|generate|configure|migration|migrate|@architect|@coder|@planner|@designer|@deepdive|@tester|phase [0-9]|spec flow|start feature|pending task)'; then

  # -------------------------------------------------------------------------
  # PASSO 4: Detectar hint de modo
  # -------------------------------------------------------------------------
  MODE_HINT="(Classificar pedido como Quick/Task/Feature/Research/UI antes de agir)"

  # Hint de Quick: correção pontual, arquivo específico, remoção, typo
  if echo "$PROMPT" | grep -qiE \
    '(fix|typo|bug|remove|delete|line [0-9]|console\.log|import|unused|dead code|refactor (the|a)|on line|in file|in src/)'; then
    MODE_HINT="(Modo provável: Quick — verificar se escopo é 1-2 arquivos antes de decidir)"
  fi

  # Hint de Task: endpoint, campo, validação, integração conhecida
  if echo "$PROMPT" | grep -qiE \
    '(endpoint|route|field|validat|middleware|add (to|in|on)|new field|new route)'; then
    MODE_HINT="(Modo provável: Task — escopo claro, @architect cria apenas specs.md)"
  fi

  # Hint de Feature: nova entidade, sistema, módulo, autenticação, arquitetura
  if echo "$PROMPT" | grep -qiE \
    '(system|module|authenticat|authoriz|permiss|oauth|jwt|payment|notificat|event.driven|microservi|architect|refactor (entire|system|architecture))'; then
    MODE_HINT="(Modo provável: Feature — Fluxo Spec Completo recomendado)"
  fi

  # Hint de Research: investigação de bug, análise de causa raiz, exploração de codebase
  if echo "$PROMPT" | grep -qiE \
    '(why (is|does|did|are)|root cause|debug|diagnos|investigate|trace|how does.*work|explore|performance issue|slow|bottleneck|security.*issue|what.s wrong|why isn.t|analyze codebase)'; then
    MODE_HINT="(Modo provável: Research — acionar @deepdive antes de planejar)"
  fi

  # Hint de UI: componente visual, design system, acessibilidade
  if echo "$PROMPT" | grep -qiE \
    '(component|button|form|modal|dialog|ui|ux|design|layout|style|accessibility|a11y|token|visual)'; then
    MODE_HINT="(Modo provável: UI — @designer cria design-spec.md + @architect cria specs.md)"
  fi

  # Hint de cobertura: modificação em src/ sem menção a testes
  COVERAGE_HINT=""
  if echo "$PROMPT" | grep -qiE '(src/|source/)' && \
     ! echo "$PROMPT" | grep -qiE '(test|spec|coverage|tester)'; then
    COVERAGE_HINT=" Lembrete: mudanças em src/ requerem cobertura de testes ≥85% no domínio."
  fi

  # PASSO 5: Capturar intent em telemetria
  TELEMETRY_DIR="${CWD}/.claude/telemetry"
  mkdir -p "$TELEMETRY_DIR" 2>/dev/null
  INTENT_MODE=$(echo "$MODE_HINT" | grep -oE "(Quick|Task|Feature|Research|UI)" | head -1 || echo "unknown")
  PROMPT_SNIPPET=$(echo "$PROMPT" | head -c 120 | tr '\n' ' ')
  jq -cn \
    --arg ts "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
    --arg sid "$(echo "$INPUT" | jq -r '.session_id // "unknown"')" \
    --arg mode "$INTENT_MODE" \
    --arg snippet "$PROMPT_SNIPPET" \
    --arg feature "$FEATURE" \
    '{timestamp: $ts, session_id: $sid, detected_mode: $mode, feature: $feature, prompt_snippet: $snippet}' \
    >> "${TELEMETRY_DIR}/intent.jsonl" 2>/dev/null

  # ---------------------------------------------------------------------------
  # PASSO 6: Episode Injection — injetar contexto de episódios similares
  # ---------------------------------------------------------------------------
  EPISODE_CONTEXT=""
  EPISODES_DIR="${CWD}/memory/episodes"

  if [ -d "$EPISODES_DIR" ] && [ "$(ls -A "$EPISODES_DIR" 2>/dev/null)" ]; then
    # Extrair keywords do prompt (palavras com 4+ chars, excluindo stopwords PT/EN)
    KEYWORDS=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]' | \
      tr -cs 'a-záéíóúãõâêîôûàèìòùç' '\n' | \
      grep -E '^.{4,}$' | \
      grep -v -E '^(para|com|que|uma|como|mais|por|quando|onde|este|essa|isso|the|and|for|with|this|that|from|have|will|your|are|not|but|can|was|all|has|its|been|they|their|more|about|which|when|what|you|how|should|would|could)$' | \
      sort -u | head -6 | paste -sd '|')

    if [ -n "$KEYWORDS" ]; then
      MATCHING=$(grep -rl -i -E "$KEYWORDS" "$EPISODES_DIR" 2>/dev/null | \
        xargs ls -t 2>/dev/null | head -2)

      if [ -n "$MATCHING" ]; then
        EPISODE_CONTEXT="

[EPISÓDIOS SIMILARES DO PASSADO — usar como referência de padrões, não como spec]"
        for EP_FILE in $MATCHING; do
          EP_NAME=$(basename "$EP_FILE" .md)
          EP_CONTENT=$(head -50 "$EP_FILE" 2>/dev/null)
          EPISODE_CONTEXT="${EPISODE_CONTEXT}

--- Episódio: ${EP_NAME} ---
${EP_CONTENT}
---"
        done
      fi
    fi
  fi

  FULL_SYSTEM_PROMPT="Você é o Tech Lead. Classifique em um dos 5 modos antes de agir: Quick (@coder direto), Task (@planner + @architect specs.md), Feature (4 fases), Research (@deepdive → @planner), UI (@designer + @architect → @coder). Use o Agent tool com subagent_type para delegar. ${BOOTSTRAP_HINT}${MODE_HINT}${COVERAGE_HINT}${EPISODE_CONTEXT}"

  jq -n --arg prompt "$FULL_SYSTEM_PROMPT" '{
    "hookSpecificOutput": {
      "hookEventName": "UserPromptSubmit",
      "additionalSystemPrompt": $prompt
    }
  }'
  exit 0
fi

# Injetar apenas bootstrap se houver sessão ativa (sem hint de modo)
if [ -n "$BOOTSTRAP_HINT" ]; then
  jq -n --arg hint "$BOOTSTRAP_HINT" '{
    "hookSpecificOutput": {
      "hookEventName": "UserPromptSubmit",
      "additionalSystemPrompt": $hint
    }
  }'
fi

exit 0
