#!/bin/bash
# =============================================================================
# Hook: prompt.sh
# Evento: UserPromptSubmit (sem matcher)
# Objetivo: Injetar contexto de routing ao @leader para tarefas de
#           desenvolvimento, com hint do modo provável (Quick/Task/Feature)
# Entrada: JSON via stdin com prompt, cwd, session_id
# =============================================================================

INPUT=$(cat)

# Extrai o texto do prompt do usuário
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')

if [ -z "$PROMPT" ]; then
  exit 0
fi

# -----------------------------------------------------------------------------
# PASSO 1: Exclusões — perguntas conceituais não devem rotear para @leader
# -----------------------------------------------------------------------------
if echo "$PROMPT" | grep -qiE \
  '^(como funciona|o que (é|são|faz)|qual (é|a|o|são)|quais (são|as|os)|por (que|quê)|quando (usar|devo)|onde (fica|está|vai)|explique|me (explique|diga|fale|mostre) o que|entend[ae]|me ajude a entender|what (is|are|does)|how (does|do|is|are)|why (is|are|does)|explain|understand|tell me (what|how|why)|can you explain|what.s the difference|como (ler|entender|usar|funciona|se usa)|o que significa)'; then
  exit 0
fi

# Prompts que terminam com "?" sem verbos imperativos claros são perguntas
if echo "$PROMPT" | grep -qE '\?$' && \
   ! echo "$PROMPT" | grep -qiE \
     '(implemente|crie|adicione|corrija|refatore|desenvolva|construa|escreva|gere|configure|migre|atualize|delete|remova)'; then
  exit 0
fi

# -----------------------------------------------------------------------------
# PASSO 2: Inclusões — verbos imperativos e palavras de ação claras
# -----------------------------------------------------------------------------
if echo "$PROMPT" | grep -qiE \
  '(implement|implemente|implementar|crie|criar|build|construir|adicione|adicionar|corrij[ao]|corrigir|refator[ae]|refatorar|desenvolv[ae]|desenvolver|feature nova|nova feature|nova task|endpoint|escreve|escreva|gere|gerar|configure|configurar|migracao|migrar|@leader|@architect|@developer|@tester|@reviewer|fase [0-9]|spec flow|iniciar feature|task pendente)'; then

  # -------------------------------------------------------------------------
  # PASSO 3: Detecta hint de modo para orientar o @leader
  # -------------------------------------------------------------------------
  MODE_HINT="(Classifique o pedido em Quick/Task/Feature antes de agir)"

  # Hint Quick: fix pontual, arquivo específico, remoção, typo
  if echo "$PROMPT" | grep -qiE \
    '(fix|corrij[ao]|typo|bug|remove|remov[ae]|delete|apaga|linha [0-9]|console\.log|import|unused|dead code|código morto|refatora (o|a|um|uma)|na linha|no arquivo|em src/)'; then
    MODE_HINT="(Modo provável: Quick — verifique se é escopo de 1-2 arquivos antes de decidir)"
  fi

  # Hint Task: endpoint, campo, validação, integração conhecida
  if echo "$PROMPT" | grep -qiE \
    '(endpoint|rota|route|campo|field|validac|validação|integra|middleware|adiciona (ao|na|no)|novo campo|nova rota)'; then
    MODE_HINT="(Modo provável: Task — escopo claro, @architect cria apenas specs.md)"
  fi

  # Hint Feature: nova entidade, sistema, módulo, autenticação, arquitetura
  if echo "$PROMPT" | grep -qiE \
    '(sistema de|módulo de|modulo de|autenticac|autenticação|autoriza|permiss|oauth|jwt|payment|pagamento|notificac|notificação|event.driven|microservi|arquitetura|refatora (toda|o sistema|a arquitetura))'; then
    MODE_HINT="(Modo provável: Feature — Spec Flow completo recomendado)"
  fi

  jq -n --arg hint "$MODE_HINT" '{
    "hookSpecificOutput": {
      "hookEventName": "UserPromptSubmit",
      "additionalSystemPrompt": ("Esta solicitação é uma tarefa de desenvolvimento. Use @leader para coordenar. @leader deve PRIMEIRO classificar o pedido em um dos 3 modos antes de agir: Quick (direto para @developer, sem changes/), Task (@architect cria specs.md light, sem PRD/design), Feature (Spec Flow completo: Research → Spec → Code → Docs). " + $hint)
    }
  }'
  exit 0
fi

exit 0
