#!/bin/bash
# =============================================================================
# Hook: lint.sh
# Evento: PostToolUse (matcher: Write|Edit|NotebookEdit)
# Objetivo: Executar biome check --write em arquivos JS/TS/JSON modificados
# Entrada: JSON via stdin com tool_input.file_path
# =============================================================================

INPUT=$(cat)

file_path=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Ignora se não há file_path no payload
if [ -z "$file_path" ] || [ "$file_path" = "null" ]; then
  exit 0
fi

# Ignora extensões que não sejam JS, TS ou JSON
if ! echo "$file_path" | grep -qE '\.(ts|tsx|js|jsx|json)$'; then
  exit 0
fi

# Ignora se o arquivo não existe no disco
if ! [ -f "$file_path" ]; then
  exit 0
fi

bunx biome check --write "$file_path" 2>&1
exit 0
