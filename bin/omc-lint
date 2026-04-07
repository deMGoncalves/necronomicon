#!/bin/bash
# =============================================================================
# Hook: lint.sh
# Event: PostToolUse (matcher: Write|Edit|NotebookEdit)
# Objective: Execute biome check --write on modified JS/TS/JSON files
# Input: JSON via stdin with tool_input.file_path
# =============================================================================

INPUT=$(cat)

file_path=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Ignore if no file_path in payload
if [ -z "$file_path" ] || [ "$file_path" = "null" ]; then
  exit 0
fi

# Ignore extensions other than JS, TS or JSON
if ! echo "$file_path" | grep -qE '\.(ts|tsx|js|jsx|json)$'; then
  exit 0
fi

# Ignore if file doesn't exist on disk
if ! [ -f "$file_path" ]; then
  exit 0
fi

bunx biome check --write "$file_path" 2>&1
exit 0
