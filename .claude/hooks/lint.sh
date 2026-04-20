#!/bin/bash
# =============================================================================
# Hook: lint.sh
# Evento: PostToolUse (matcher: Write|Edit|NotebookEdit)
# Objetivo: Auto-formatar arquivos JS/TS/JSON usando o linter configurado no projeto
# Entrada: JSON via stdin com tool_input.file_path
#
# Detecção de linter (ordem de prioridade):
#   1. Biome  → biome.json ou biome.jsonc na raiz do projeto
#   2. ESLint → .eslintrc.* ou eslint.config.*
#   3. Deno   → deno.json
#   4. Sem config → no-op silencioso
# =============================================================================

INPUT=$(cat)

file_path=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Ignorar se não há file_path no payload
if [ -z "$file_path" ] || [ "$file_path" = "null" ]; then
  exit 0
fi

# Ignorar extensões diferentes de JS, TS ou JSON
if ! echo "$file_path" | grep -qE '\.(ts|tsx|js|jsx|json)$'; then
  exit 0
fi

# Ignorar se arquivo não existe no disco
if ! [ -f "$file_path" ]; then
  exit 0
fi

# Obter raiz do projeto
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
PROJECT_ROOT="${CWD}"

# Detectar linter configurado e executar
if [ -f "${PROJECT_ROOT}/biome.json" ] || [ -f "${PROJECT_ROOT}/biome.jsonc" ]; then
  bunx biome check --write "$file_path" 2>&1
elif [ -f "${PROJECT_ROOT}/.eslintrc.js" ] || \
     [ -f "${PROJECT_ROOT}/.eslintrc.cjs" ] || \
     [ -f "${PROJECT_ROOT}/.eslintrc.json" ] || \
     [ -f "${PROJECT_ROOT}/eslint.config.js" ] || \
     [ -f "${PROJECT_ROOT}/eslint.config.mjs" ]; then
  npx eslint --fix "$file_path" 2>&1
elif [ -f "${PROJECT_ROOT}/deno.json" ] || [ -f "${PROJECT_ROOT}/deno.jsonc" ]; then
  deno fmt "$file_path" 2>&1
fi
# Sem linter configurado: no-op silencioso

exit 0
