#!/bin/bash
# =============================================================================
# Hook: loop.sh
# Evento: Stop (sem matcher)
# Objetivo: Bloquear finalização se houver tarefas pendentes em changes/*/tasks.md
#           e exibir contadores de tentativas para feedback de re-spec
#
# ROTA DE ESCAPE: criar .claude/.loop-skip para forçar saída do loop:
#   touch .claude/.loop-skip  →  rm .claude/.loop-skip para reativar
# =============================================================================

INPUT=$(cat)

# Prevenir loop infinito: Stop hook ativo indica que já estamos em continuação
STOP_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active')
if [ "$STOP_ACTIVE" = "true" ]; then
  exit 0
fi

CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# Rota de escape: contornar verificação sem bloquear
if [ -f "${CWD}/.claude/.loop-skip" ]; then
  exit 0
fi

# Buscar tasks.md dentro de changes/*/tasks.md
TASKS_FILES=$(find "${CWD}/changes" -name "tasks.md" -maxdepth 2 2>/dev/null | sort)
ROOT_TASKS="${CWD}/tasks.md"
if [ -f "$ROOT_TASKS" ]; then
  TASKS_FILES="$ROOT_TASKS $TASKS_FILES"
fi

# Nenhum tasks.md encontrado
if [ -z "$(echo "$TASKS_FILES" | tr -d '[:space:]')" ]; then
  exit 0
fi

# Verificar cada tasks.md por tarefas pendentes
PENDING_FILE=""
for TASKS_FILE in $TASKS_FILES; do
  if [ -f "$TASKS_FILE" ] && grep -qE '^\s*-\s*\[ \]' "$TASKS_FILE" 2>/dev/null; then
    PENDING_FILE="$TASKS_FILE"
    break
  fi
done

# Sem tarefas pendentes: permitir finalização
if [ -z "$PENDING_FILE" ]; then
  exit 0
fi

# Exibir caminho relativo
RELATIVE_PATH="${PENDING_FILE#${CWD}/}"

# Extrair contadores de tentativas para feedback contextual
CODER_ATT=$(grep -oE "attempts-coder: [0-9]+" "$PENDING_FILE" 2>/dev/null | grep -oE "[0-9]+" || echo "0")
TESTER_ATT=$(grep -oE "attempts-tester: [0-9]+" "$PENDING_FILE" 2>/dev/null | grep -oE "[0-9]+" || echo "0")
ATTEMPTS_INFO="Tentativas: coder=${CODER_ATT}/3, tester=${TESTER_ATT}/3"

# Aviso de re-spec quando @coder está próximo do limite
RESPEC_WARNING=""
if [ "$CODER_ATT" -ge 2 ] 2>/dev/null; then
  RESPEC_WARNING=" ⚠️ Re-spec recomendado — @architect deve revisar specs.md antes da próxima tentativa."
fi

jq -n --arg path "$RELATIVE_PATH" --arg attempts "$ATTEMPTS_INFO" --arg warning "$RESPEC_WARNING" '{
  decision: "block",
  reason: ("Tarefas pendentes em " + $path + " | " + $attempts + $warning + " — Continuar as tarefas incompletas ou criar .claude/.loop-skip para forçar saída.")
}'
exit 0
