#!/bin/bash
# =============================================================================
# Hook: guard.sh
# Evento: PostToolUse (matcher: Write|Edit)
# Objetivo: Detectar violações de regras 🔴 Críticas em arquivos JS/TS escritos
# Entrada: JSON via stdin com tool_input.file_path
#
# Regras verificadas:
#   Rule 007 — Máximo 50 linhas de código por arquivo (excluindo vazias e comentários)
#   Rule 033 — Máximo 3 parâmetros por função
#   Rule 030 — Proibição de eval() e new Function()
#   Rule 024 — Constantes mágicas (números > 1 dígito fora de const/let/var)
# =============================================================================

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Ignorar se não há file_path
if [ -z "$FILE_PATH" ] || [ "$FILE_PATH" = "null" ]; then
  exit 0
fi

# Apenas arquivos JS/TS
if ! echo "$FILE_PATH" | grep -qE '\.(ts|tsx|js|jsx)$'; then
  exit 0
fi

# Ignorar arquivos de teste (exceção Rule 007)
if echo "$FILE_PATH" | grep -qE '\.(test|spec)\.(ts|tsx|js|jsx)$'; then
  exit 0
fi

# Ignorar se arquivo não existe
if ! [ -f "$FILE_PATH" ]; then
  exit 0
fi

CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
RELATIVE_PATH="${FILE_PATH#${CWD}/}"

VIOLATIONS=""

# ─── Rule 007: LOC > 50 ──────────────────────────────────────────────────────
# Contar linhas não-vazias e não-comentário
LOC=$(grep -cE '^[[:space:]]*[^/[:space:]]' "$FILE_PATH" 2>/dev/null || echo "0")
if [ "$LOC" -gt 50 ] 2>/dev/null; then
  VIOLATIONS="${VIOLATIONS}  [Rule 007] 🔴 Limite de linhas: ${LOC} linhas de código (máximo: 50). Extrair responsabilidades para classes separadas.\n"
fi

# ─── Rule 033: Funções com > 3 parâmetros ────────────────────────────────────
LONG_PARAMS=$(grep -nE 'function[[:space:]]+\w*[[:space:]]*\([^)]*,[^)]*,[^)]*,[^)]' "$FILE_PATH" 2>/dev/null | head -5)
if [ -z "$LONG_PARAMS" ]; then
  # Também detectar arrow functions e métodos
  LONG_PARAMS=$(grep -nE '(const|let|var)[[:space:]]+\w+[[:space:]]*=[[:space:]]*\([^)]*,[^)]*,[^)]*,[^)]+\)[[:space:]]*=>' "$FILE_PATH" 2>/dev/null | head -5)
fi
if [ -n "$LONG_PARAMS" ]; then
  VIOLATIONS="${VIOLATIONS}  [Rule 033] 🔴 Função com > 3 parâmetros detectada. Agrupar em objeto de parâmetro (DTO):\n$(echo "$LONG_PARAMS" | sed 's/^/    /')\n"
fi

# ─── Rule 030: eval() e new Function() ───────────────────────────────────────
UNSAFE=$(grep -nE '\beval\s*\(|new\s+Function\s*\(' "$FILE_PATH" 2>/dev/null | \
  grep -v '^\s*[//*]' | head -3)
if [ -n "$UNSAFE" ]; then
  VIOLATIONS="${VIOLATIONS}  [Rule 030] 🔴 Função insegura detectada (eval/new Function — vetor de RCE):\n$(echo "$UNSAFE" | sed 's/^/    /')\n"
fi

# ─── Rule 024: Magic numbers (números > 1 dígito fora de declaração de constante) ──
MAGIC=$(grep -nE '[^a-zA-Z_0-9][0-9]{2,}[^a-zA-Z_0-9.]' "$FILE_PATH" 2>/dev/null | \
  grep -vE '^\s*(const|let|var|\/\/|\/\*|\*)' | \
  grep -vE 'Rule|version|0x[0-9a-fA-F]+' | \
  head -3)
if [ -n "$MAGIC" ]; then
  VIOLATIONS="${VIOLATIONS}  [Rule 024] 🟠 Constante mágica detectada. Substituir por constante nomeada (UPPER_SNAKE_CASE):\n$(echo "$MAGIC" | sed 's/^/    /')\n"
fi

# Sem violações: permitir
if [ -z "$VIOLATIONS" ]; then
  exit 0
fi

# Verificar se há violação CRÍTICA (🔴) para bloquear ou apenas avisar (🟠)
HAS_CRITICAL=$(echo "$VIOLATIONS" | grep -c "🔴" || echo "0")

if [ "$HAS_CRITICAL" -gt 0 ] 2>/dev/null; then
  # Bloquear para violações críticas
  jq -n --arg file "$RELATIVE_PATH" --arg violations "$VIOLATIONS" '{
    decision: "block",
    reason: ("🔴 Violações críticas detectadas em " + $file + ":\n\n" + $violations + "\nCorrigir antes de submeter.")
  }'
else
  # Apenas notificar para violações altas/médias (não bloquear)
  jq -n --arg file "$RELATIVE_PATH" --arg violations "$VIOLATIONS" '{
    decision: "approve",
    reason: ("⚠️ Melhorias sugeridas em " + $file + ":\n\n" + $violations)
  }'
fi
exit 0
