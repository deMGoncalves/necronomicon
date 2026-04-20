#!/bin/bash
# =============================================================================
# Hook: security.sh
# Evento: PostToolUse (matcher: Write|Edit)
# Objetivo: Bloquear se credenciais hardcoded forem detectadas no arquivo escrito
# Entrada: JSON via stdin com tool_input.file_path
#
# Detecta: API keys, tokens, senhas, secrets hardcoded (Rule 030 + Rule 042)
# Ignora: process.env., variáveis de template ${}, comentários, arquivos .example
# =============================================================================

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Ignorar se não há file_path
if [ -z "$FILE_PATH" ] || [ "$FILE_PATH" = "null" ]; then
  exit 0
fi

# Ignorar arquivos de exemplo/template
if echo "$FILE_PATH" | grep -qE '\.(example|sample|template|test|spec)\.|\.example$'; then
  exit 0
fi

# Extensões relevantes para escaneamento
if ! echo "$FILE_PATH" | grep -qE '\.(ts|tsx|js|jsx|py|json|yaml|yml|env|sh|bash)$' && \
   ! echo "$FILE_PATH" | grep -qE '\.env'; then
  exit 0
fi

# Ignorar se arquivo não existe
if ! [ -f "$FILE_PATH" ]; then
  exit 0
fi

# Padrões de credencial hardcoded
# Excluir: process.env., variáveis ${}, strings de exemplo, comentários

FINDINGS=""

# Padrão 1: atribuição direta de credencial (key = "valor")
MATCH=$(grep -nE '(api[_-]?key|password|passwd|secret[_-]?key|auth[_-]?token|private[_-]?key|access[_-]?token|client[_-]?secret)\s*[=:]\s*['"'"'"][^'"'"'"${}][^'"'"'"]{7,}['"'"'"]' "$FILE_PATH" 2>/dev/null | \
  grep -v 'process\.env\.' | \
  grep -v '\$\{' | \
  grep -v '^\s*[#/]' | \
  grep -v 'your[_-]\|example\|placeholder\|replace\|CHANGE_ME\|TODO')

if [ -n "$MATCH" ]; then
  FINDINGS="${FINDINGS}${MATCH}\n"
fi

# Padrão 2: tokens GitHub (ghp_, gho_, ghs_, ghr_)
MATCH=$(grep -nE 'gh[phosr]_[A-Za-z0-9]{36}' "$FILE_PATH" 2>/dev/null | \
  grep -v 'process\.env\.' | \
  grep -v '\$\{' | \
  grep -v '^\s*[#/]')

if [ -n "$MATCH" ]; then
  FINDINGS="${FINDINGS}${MATCH}\n"
fi

# Padrão 3: API keys comuns (sk-, pk-, rk_)
MATCH=$(grep -nE '"(sk|pk|rk)[-_][a-zA-Z0-9]{20,}"' "$FILE_PATH" 2>/dev/null | \
  grep -v 'process\.env\.' | \
  grep -v '\$\{' | \
  grep -v '^\s*[#/]')

if [ -n "$MATCH" ]; then
  FINDINGS="${FINDINGS}${MATCH}\n"
fi

# Padrão 4: Bearer token hardcoded
MATCH=$(grep -nE 'Bearer\s+[A-Za-z0-9+/]{20,}[=]*' "$FILE_PATH" 2>/dev/null | \
  grep -v 'process\.env\.' | \
  grep -v '\$\{' | \
  grep -v '^\s*[#/]')

if [ -n "$MATCH" ]; then
  FINDINGS="${FINDINGS}${MATCH}\n"
fi

# Sem findings: permitir
if [ -z "$FINDINGS" ]; then
  exit 0
fi

# Credencial detectada: bloquear com localização
RELATIVE_PATH="${FILE_PATH#$(echo "$INPUT" | jq -r '.cwd // empty')/}"

jq -n --arg file "$RELATIVE_PATH" --arg findings "$FINDINGS" '{
  decision: "block",
  reason: ("🔴 SECURITY [Rule 042]: Credencial hardcoded detectada em " + $file + ".\n\nLocalizações:\n" + $findings + "\nUse variáveis de ambiente (process.env.NOME) em vez de valores literais. Nunca versionar credenciais reais.")
}'
exit 0
