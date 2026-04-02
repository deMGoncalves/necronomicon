#!/bin/bash
# =============================================================================
# Hook: loop.sh
# Evento: Stop (sem matcher)
# Objetivo: Bloquear finalização se houver tarefas pendentes em changes/*/tasks.md
# Entrada: JSON via stdin com stop_hook_active, cwd, last_assistant_message
#
# ESCAPE HATCH: Para forçar saída do loop (feature cancelada ou workflow travado),
# crie o arquivo .claude/.loop-skip na raiz do projeto:
#   touch .claude/.loop-skip
# Remova quando quiser reativar o loop:
#   rm .claude/.loop-skip
# =============================================================================

INPUT=$(cat)

# Previne loop infinito: Claude Code seta stop_hook_active=true quando
# já está em continuação por causa deste hook
STOP_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active')
if [ "$STOP_ACTIVE" = "true" ]; then
  exit 0
fi

CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# Escape hatch: se .claude/.loop-skip existir, bypass o check sem bloquear
if [ -f "${CWD}/.claude/.loop-skip" ]; then
  exit 0
fi

# Busca tasks.md dentro de changes/*/tasks.md (padrão Spec Flow)
# Fallback: verifica tasks.md na raiz do projeto
TASKS_FILES=$(find "${CWD}/changes" -name "tasks.md" -maxdepth 2 2>/dev/null | sort)
ROOT_TASKS="${CWD}/tasks.md"
if [ -f "$ROOT_TASKS" ]; then
  TASKS_FILES="$ROOT_TASKS $TASKS_FILES"
fi

# Sem nenhum tasks.md encontrado: nada a verificar
if [ -z "$(echo "$TASKS_FILES" | tr -d '[:space:]')" ]; then
  exit 0
fi

# Verifica cada tasks.md por tarefas pendentes (checkboxes não marcados)
PENDING_FILE=""
for TASKS_FILE in $TASKS_FILES; do
  if [ -f "$TASKS_FILE" ] && grep -qE '^\s*-\s*\[ \]' "$TASKS_FILE" 2>/dev/null; then
    PENDING_FILE="$TASKS_FILE"
    break
  fi
done

# Sem tarefas pendentes: permite finalizar normalmente
if [ -z "$PENDING_FILE" ]; then
  exit 0
fi

# Exibe o caminho relativo para mensagem clara ao @leader
RELATIVE_PATH="${PENDING_FILE#${CWD}/}"

jq -n --arg path "$RELATIVE_PATH" '{
  decision: "block",
  reason: ("Tarefas pendentes encontradas em " + $path + ". @leader: verifique o arquivo e continue as tarefas incompletas antes de finalizar. Se o workflow estiver travado, crie .claude/.loop-skip para forçar saída.")
}'
exit 0
