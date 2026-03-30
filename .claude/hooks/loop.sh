#!/bin/bash
# =============================================================================
# Hook: loop.sh
# Evento: Stop (sem matcher)
# Objetivo: Perguntar ao @leader se realmente finalizou; continuar se houver
#           tarefas pendentes em tasks.md
# Entrada: JSON via stdin com stop_hook_active, cwd, last_assistant_message
# =============================================================================

INPUT=$(cat)

# Previne loop infinito: Claude Code seta stop_hook_active=true quando
# já está em continuação por causa deste hook
STOP_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active')
if [ "$STOP_ACTIVE" = "true" ]; then
  exit 0
fi

CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
TASKS_FILE="${CWD}/tasks.md"

# Sem tasks.md não há o que verificar
if [ ! -f "$TASKS_FILE" ]; then
  exit 0
fi

# Detecta tarefas pendentes: checkboxes não marcados ou status in_progress
if grep -qE '^\s*-\s*\[ \]|\bstatus\b.*\bin.progress\b' "$TASKS_FILE" 2>/dev/null; then
  jq -n '{
    decision: "block",
    reason: "tasks.md contém tarefas pendentes. @leader: verifique tasks.md e continue as tarefas incompletas antes de finalizar."
  }'
  exit 0
fi

exit 0
