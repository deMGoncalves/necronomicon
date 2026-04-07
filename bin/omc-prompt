#!/bin/bash
# =============================================================================
# Hook: prompt.sh
# Event: UserPromptSubmit (no matcher)
# Objective: Inject routing context to @leader for development tasks,
#            with hint of probable mode (Quick/Task/Feature)
# Input: JSON via stdin with prompt, cwd, session_id
# =============================================================================

INPUT=$(cat)

# Extract user prompt text
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')

if [ -z "$PROMPT" ]; then
  exit 0
fi

# -----------------------------------------------------------------------------
# STEP 1: Exclusions — conceptual questions should not route to @leader
# -----------------------------------------------------------------------------
if echo "$PROMPT" | grep -qiE \
  '^(how (does|do|is|are)|what (is|are|does)|which (is|are)|why (is|are|does)|when (to use|should)|where (is|does|goes)|explain|tell me what|understand|help me understand|can you explain|what.s the difference)'; then
  exit 0
fi

# Prompts ending with "?" without clear imperative verbs are questions
if echo "$PROMPT" | grep -qE '\?$' && \
   ! echo "$PROMPT" | grep -qiE \
     '(implement|create|add|fix|refactor|develop|build|write|generate|configure|migrate|update|delete|remove)'; then
  exit 0
fi

# -----------------------------------------------------------------------------
# STEP 2: Inclusions — imperative verbs and clear action words
# -----------------------------------------------------------------------------
if echo "$PROMPT" | grep -qiE \
  '(implement|create|build|add|fix|refactor|develop|new feature|feature|new task|endpoint|write|generate|configure|migration|migrate|@leader|@architect|@developer|@tester|@reviewer|phase [0-9]|spec flow|start feature|pending task)'; then

  # -------------------------------------------------------------------------
  # STEP 3: Detect mode hint to guide @leader
  # -------------------------------------------------------------------------
  MODE_HINT="(Classify request as Quick/Task/Feature before acting)"

  # Quick hint: point fix, specific file, removal, typo
  if echo "$PROMPT" | grep -qiE \
    '(fix|typo|bug|remove|delete|line [0-9]|console\.log|import|unused|dead code|refactor (the|a)|on line|in file|in src/)'; then
    MODE_HINT="(Probable mode: Quick — verify if scope is 1-2 files before deciding)"
  fi

  # Task hint: endpoint, field, validation, known integration
  if echo "$PROMPT" | grep -qiE \
    '(endpoint|route|field|validat|middleware|add (to|in|on)|new field|new route)'; then
    MODE_HINT="(Probable mode: Task — clear scope, @architect creates only specs.md)"
  fi

  # Feature hint: new entity, system, module, authentication, architecture
  if echo "$PROMPT" | grep -qiE \
    '(system|module|authenticat|authoriz|permiss|oauth|jwt|payment|notificat|event.driven|microservi|architect|refactor (entire|system|architecture))'; then
    MODE_HINT="(Probable mode: Feature — Complete Spec Flow recommended)"
  fi

  jq -n --arg hint "$MODE_HINT" '{
    "hookSpecificOutput": {
      "hookEventName": "UserPromptSubmit",
      "additionalSystemPrompt": ("This request is a development task. Use @leader to coordinate. @leader must FIRST classify request into one of 3 modes before acting: Quick (direct to @developer, no changes/), Task (@architect creates light specs.md, no PRD/design), Feature (Complete Spec Flow: Research → Spec → Code → Docs). " + $hint)
    }
  }'
  exit 0
fi

exit 0
