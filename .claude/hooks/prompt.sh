#!/bin/bash
# =============================================================================
# Hook: prompt.sh
# Evento: UserPromptSubmit (sem matcher)
# Objetivo: Injetar contexto de routing ao @leader para tarefas de desenvolvimento
# Entrada: JSON via stdin com prompt, cwd, session_id
# =============================================================================

INPUT=$(cat)

# Extrai o texto do prompt do usuário
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')

if [ -z "$PROMPT" ]; then
  exit 0
fi

# Detecta se o prompt parece uma tarefa de desenvolvimento
# Palavras-chave que indicam intenção de desenvolvimento/feature
if echo "$PROMPT" | grep -qiE \
  '(implement|implemente|implementar|create|crie|criar|build|construir|add|adicionar|fix|corrija|corrigir|refactor|refatora|refatorar|develop|desenvolver|feature|task|tarefa|spec|design|test|teste|testar|review|revisar|docs|documentar|documentacao|@leader|@architect|@developer|@tester|@reviewer|fase [0-9]|workflow|pipeline|migrar|migracao|endpoint|api|service|module|componente|component|schema|interface|repository)'; then

  jq -n '{
    "hookSpecificOutput": {
      "hookEventName": "UserPromptSubmit",
      "additionalSystemPrompt": "Esta solicitação parece uma tarefa de desenvolvimento. Use @leader para coordenar o Spec Flow (Research → Spec → Code → Docs). @leader analisa o pedido, determina o escopo (fluxo completo ou parcial) e delega para os sub-agentes: @architect (pesquisa/design/docs), @developer (implementação), @tester (testes), @reviewer (code review). O workflow não é rígido — @leader adapta conforme o que o usuário realmente precisa."
    }
  }'
  exit 0
fi

exit 0
