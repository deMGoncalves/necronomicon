#!/bin/bash
# =============================================================================
# Hook: loop.sh
# Event: Stop (no matcher)
# Objective: Block finalization if there are pending tasks in changes/*/tasks.md
# Input: JSON via stdin with stop_hook_active, cwd, last_assistant_message
#
# ESCAPE HATCH: To force exit from loop (cancelled feature or stuck workflow),
# create file .claude/.loop-skip at project root:
#   touch .claude/.loop-skip
# Remove when you want to reactivate loop:
#   rm .claude/.loop-skip
# =============================================================================

INPUT=$(cat)

# Prevent infinite loop: Claude Code sets stop_hook_active=true when
# already in continuation because of this hook
STOP_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active')
if [ "$STOP_ACTIVE" = "true" ]; then
  exit 0
fi

CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# Escape hatch: if .claude/.loop-skip exists, bypass check without blocking
if [ -f "${CWD}/.claude/.loop-skip" ]; then
  exit 0
fi

# Search for tasks.md inside changes/*/tasks.md (Spec Flow pattern)
# Fallback: check tasks.md at project root
TASKS_FILES=$(find "${CWD}/changes" -name "tasks.md" -maxdepth 2 2>/dev/null | sort)
ROOT_TASKS="${CWD}/tasks.md"
if [ -f "$ROOT_TASKS" ]; then
  TASKS_FILES="$ROOT_TASKS $TASKS_FILES"
fi

# No tasks.md found: nothing to verify
if [ -z "$(echo "$TASKS_FILES" | tr -d '[:space:]')" ]; then
  exit 0
fi

# Check each tasks.md for pending tasks (unchecked checkboxes)
PENDING_FILE=""
for TASKS_FILE in $TASKS_FILES; do
  if [ -f "$TASKS_FILE" ] && grep -qE '^\s*-\s*\[ \]' "$TASKS_FILE" 2>/dev/null; then
    PENDING_FILE="$TASKS_FILE"
    break
  fi
done

# No pending tasks: allow normal finalization
if [ -z "$PENDING_FILE" ]; then
  exit 0
fi

# Display relative path for clear message to @leader
RELATIVE_PATH="${PENDING_FILE#${CWD}/}"

jq -n --arg path "$RELATIVE_PATH" '{
  decision: "block",
  reason: ("Pending tasks found in " + $path + ". @leader: check file and continue incomplete tasks before finalizing. If workflow is stuck, create .claude/.loop-skip to force exit.")
}'
exit 0
