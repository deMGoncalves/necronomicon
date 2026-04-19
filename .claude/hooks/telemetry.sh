#!/bin/bash
# =============================================================================
# Hook: telemetry.sh
# Evento: Stop (sem matcher)
# Objetivo: Observabilidade — registrar trace estruturado de cada sessão em
#           .claude/telemetry/sessions.jsonl para fechar feedback loops internos
#
# Campos registrados: timestamp, session_id, cwd, feature ativa, tentativas,
#                     tarefas completas/pendentes, modo estimado
# =============================================================================

INPUT=$(cat)

STOP_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // "false"')
if [ "$STOP_ACTIVE" = "true" ]; then
  exit 0
fi

CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

TELEMETRY_DIR="${CWD}/.claude/telemetry"
mkdir -p "$TELEMETRY_DIR" 2>/dev/null

# Coletar contexto de sessão ativa
FEATURE_NAME=""
PENDING_COUNT=0
DONE_COUNT=0
CODER_ATTEMPTS=0
TESTER_ATTEMPTS=0
MODE="unknown"

TASKS_FILE=$(find "${CWD}/changes" -name "tasks.md" -maxdepth 2 2>/dev/null | sort | head -1)

if [ -n "$TASKS_FILE" ] && [ -f "$TASKS_FILE" ]; then
  FEATURE_NAME=$(echo "$TASKS_FILE" | sed "s|${CWD}/changes/||" | sed "s|/tasks.md||")
  PENDING_COUNT=$(grep -cE "^\s*-\s*\[ \]" "$TASKS_FILE" 2>/dev/null || echo 0)
  DONE_COUNT=$(grep -cE "^\s*-\s*\[x\]" "$TASKS_FILE" 2>/dev/null || echo 0)
  CODER_ATTEMPTS=$(grep -oE "attempts-coder: [0-9]+" "$TASKS_FILE" 2>/dev/null | grep -oE "[0-9]+" || echo 0)
  TESTER_ATTEMPTS=$(grep -oE "attempts-tester: [0-9]+" "$TASKS_FILE" 2>/dev/null | grep -oE "[0-9]+" || echo 0)
  MODE_RAW=$(grep -oE "mode: (Quick|Task|Feature|Research|UI)" "$TASKS_FILE" 2>/dev/null | head -1)
  MODE=$(echo "$MODE_RAW" | grep -oE "(Quick|Task|Feature|Research|UI)" || echo "unknown")
fi

# Verificar se guard.sh registrou violações recentes
VIOLATIONS_FILE="${CWD}/.claude/.last-violations"
VIOLATIONS="[]"
if [ -f "$VIOLATIONS_FILE" ]; then
  VIOLATIONS=$(cat "$VIOLATIONS_FILE" 2>/dev/null || echo "[]")
  rm -f "$VIOLATIONS_FILE"
fi

# Montar payload JSON e anexar ao log de sessões
jq -cn \
  --arg ts "$TIMESTAMP" \
  --arg sid "$SESSION_ID" \
  --arg cwd "$CWD" \
  --arg feature "$FEATURE_NAME" \
  --argjson pending "$PENDING_COUNT" \
  --argjson done "$DONE_COUNT" \
  --argjson coder "$CODER_ATTEMPTS" \
  --argjson tester "$TESTER_ATTEMPTS" \
  --arg mode "$MODE" \
  --argjson violations "$VIOLATIONS" \
  '{
    timestamp: $ts,
    session_id: $sid,
    cwd: $cwd,
    feature: $feature,
    mode: $mode,
    tasks: { pending: $pending, done: $done },
    attempts: { coder: $coder, tester: $tester },
    violations: $violations
  }' >> "${TELEMETRY_DIR}/sessions.jsonl" 2>/dev/null

# Episodic Memory: registrar episódio quando feature é concluída
if [ "$PENDING_COUNT" -eq 0 ] && [ "$DONE_COUNT" -gt 0 ] && [ -n "$FEATURE_NAME" ]; then
  EPISODE_DIR="${CWD}/memory/episodes"
  mkdir -p "$EPISODE_DIR" 2>/dev/null
  EPISODE_FILE="${EPISODE_DIR}/$(date +%Y-%m-%d)_${FEATURE_NAME}.md"

  # Gravar apenas uma vez por feature
  if [ ! -f "$EPISODE_FILE" ]; then
    FEATURE_PATH="${CWD}/changes/${FEATURE_NAME}"

    SPECS_SUMMARY=""
    if [ -f "${FEATURE_PATH}/specs.md" ]; then
      SPECS_SUMMARY=$(head -60 "${FEATURE_PATH}/specs.md" 2>/dev/null)
    fi

    DESIGN_SUMMARY=""
    if [ -f "${FEATURE_PATH}/design.md" ]; then
      DESIGN_SUMMARY=$(head -30 "${FEATURE_PATH}/design.md" 2>/dev/null)
    fi

    FINDINGS_SUMMARY=""
    if [ -f "${FEATURE_PATH}/findings.md" ]; then
      FINDINGS_SUMMARY=$(head -20 "${FEATURE_PATH}/findings.md" 2>/dev/null)
    fi

    cat > "$EPISODE_FILE" << EPISODE_EOF
---
date: $(date -u +"%Y-%m-%d")
feature: ${FEATURE_NAME}
mode: ${MODE}
attempts_coder: ${CODER_ATTEMPTS}
attempts_tester: ${TESTER_ATTEMPTS}
tasks_completed: ${DONE_COUNT}
---

## Specs

${SPECS_SUMMARY}

## Decisões de Design

${DESIGN_SUMMARY}

## Findings

${FINDINGS_SUMMARY}
EPISODE_EOF
  fi
fi

# Skill Distillation: marcar candidatos quando coder passou na primeira tentativa
if [ "$PENDING_COUNT" -eq 0 ] && [ "$DONE_COUNT" -gt 0 ] && \
   [ -n "$FEATURE_NAME" ] && [ "$CODER_ATTEMPTS" = "1" ]; then
  PATTERNS_DIR="${CWD}/memory/patterns"
  mkdir -p "$PATTERNS_DIR" 2>/dev/null
  CANDIDATES_FILE="${PATTERNS_DIR}/candidates.md"

  # Adicionar entrada apenas se ainda não registrada
  if ! grep -q "^### .*${FEATURE_NAME}" "$CANDIDATES_FILE" 2>/dev/null; then
    cat >> "$CANDIDATES_FILE" << CANDIDATE_EOF

### $(date +%Y-%m-%d) — ${FEATURE_NAME}
- **Modo**: ${MODE}
- **Tentativas coder/tester**: ${CODER_ATTEMPTS}/${TESTER_ATTEMPTS}
- **Tasks concluídas**: ${DONE_COUNT}
- **Specs**: \`changes/${FEATURE_NAME}/specs.md\`
- [ ] Revisado — skill atualizado ou descartado
CANDIDATE_EOF
  fi
fi

exit 0
