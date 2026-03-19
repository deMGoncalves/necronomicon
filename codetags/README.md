# Codetags

Convenção para uso de codetags (marcações padronizadas em comentários) para comunicação e rastreamento de ações no código.

---

## Overview

Codetags são marcadores padronizados em comentários que facilitam a comunicação entre desenvolvedores e o rastreamento de ações pendentes no código.

```
┌─────────────────────────────────────────────────────────────────┐
│                         CODETAGS                                 │
├─────────────────┬─────────────────┬─────────────────────────────┤
│   🔴 CRITICAL   │   🟠 HIGH       │   🟡 MEDIUM    │   🟢 LOW   │
│  (Resolve Now)  │  (Resolve Soon) │  (Improvement) │  (Info)    │
├─────────────────┼─────────────────┼─────────────────────────────┤
│ • FIXME         │ • HACK          │ • TODO         │ • NOTE     │
│ • BUG           │ • DEPRECATED    │ • OPTIMIZE     │ • INFO     │
│ • SECURITY      │ • REFACTOR      │ • PERF         │ • IDEA     │
│ • XXX           │ • CLEANUP       │ • REVIEW       │ • QUESTION │
└─────────────────┴─────────────────┴─────────────────────────────┘
```

## Estrutura

### 🔴 Critical - Resolver Urgentemente

| Tag | Arquivo | Uso |
|-----|---------|-----|
| FIXME | [001_fixme.md](critical/001_fixme.md) | Bug confirmado que deve ser corrigido |
| BUG | [002_bug.md](critical/002_bug.md) | Defeito conhecido documentado |
| SECURITY | [003_security.md](critical/003_security.md) | Vulnerabilidade de segurança |
| XXX | [004_xxx.md](critical/004_xxx.md) | Alerta severo sobre código problemático |

### 🟠 High - Resolver em Breve

| Tag | Arquivo | Uso |
|-----|---------|-----|
| HACK | [001_hack.md](high/001_hack.md) | Solução temporária/workaround |
| DEPRECATED | [002_deprecated.md](high/002_deprecated.md) | Código obsoleto a ser removido |
| REFACTOR | [003_refactor.md](high/003_refactor.md) | Código que viola princípios |
| CLEANUP | [004_cleanup.md](high/004_cleanup.md) | Código desorganizado |

### 🟡 Medium - Melhorias Desejáveis

| Tag | Arquivo | Uso |
|-----|---------|-----|
| TODO | [001_todo.md](medium/001_todo.md) | Tarefa pendente planejada |
| OPTIMIZE | [002_optimize.md](medium/002_optimize.md) | Otimização de performance |
| PERF | [003_perf.md](medium/003_perf.md) | Ponto de gargalo identificado |
| REVIEW | [004_review.md](medium/004_review.md) | Revisão necessária |

### 🟢 Low - Informativo

| Tag | Arquivo | Uso |
|-----|---------|-----|
| NOTE | [001_note.md](low/001_note.md) | Nota importante sobre decisão |
| INFO | [002_info.md](low/002_info.md) | Detalhe técnico adicional |
| IDEA | [003_idea.md](low/003_idea.md) | Sugestão futura |
| QUESTION | [004_question.md](low/004_question.md) | Dúvida sobre abordagem |

## Formato de Uso

```javascript
// TAG: descrição concisa
// TAG: [severidade] descrição com contexto
// TAG: descrição - ação necessária
```

### Exemplos

```javascript
// FIXME: divisão por zero quando items está vazio
// BUG: cálculo incorreto de desconto para quantidades negativas
// SECURITY: sanitizar input antes de usar em query SQL
// TODO: implementar validação de email
// HACK: workaround para bug no Safari - remover quando atualizar
// REFACTOR: extrair lógica de cálculo para classe separada (SRP)
```

## Regras de Escrita

| Regra | Descrição |
|-------|-----------|
| Sempre MAIÚSCULAS | Tags em UPPERCASE para destaque |
| Dois-pontos após tag | Usar `: ` para separar tag da descrição |
| Descrição concisa | Máximo uma linha, ser direto e específico |
| Evitar redundância | Não repetir informação óbvia do código |
| Contexto quando necessário | Adicionar autor, data ou ticket se relevante |

## Pesquisabilidade

```bash
# Buscar todas as tags
grep -rn "TODO\|FIXME\|HACK\|BUG\|SECURITY" src/

# Buscar tag específica
grep -rn "FIXME:" src/

# Buscar por palavra-chave
grep -rn "TODO:.*auth" src/

# Contar tags por arquivo
grep -rc "TODO:" src/ | grep -v ":0"

# Listar todas as tags críticas
grep -rn "FIXME:\|BUG:\|SECURITY:\|XXX:" src/
```

## Ciclo de Vida

| Estágio | Ação |
|---------|------|
| **Criação** | Adicionar tag ao identificar necessidade |
| **Rastreamento** | Revisar tags em code reviews |
| **Resolução** | Resolver ação e remover tag completamente |
| **Nunca deixar** | Tags não devem persistir indefinidamente |

## Priorização de Resolução

| Quando Resolver | Tags |
|-----------------|------|
| **Antes do commit** | FIXME, BUG, SECURITY em código crítico |
| **Antes do merge** | XXX, HACK, FIXME em novas features |
| **Sprint atual** | TODO planejado, REFACTOR identificado |
| **Próxima sprint** | OPTIMIZE, CLEANUP, REVIEW |
| **Backlog** | IDEA, sugestões de melhoria |

## Integração com Workflow

| Momento | Ação |
|---------|------|
| Durante desenvolvimento | Adicionar tags conforme necessário |
| Antes do commit | Revisar e resolver tags críticas |
| Code review | Verificar novas tags e questionar permanência |
| Sprint planning | Priorizar resolução de tags acumuladas |
| Refactoring | Aproveitar para resolver tags antigas na área |

## Proibições

| O que Evitar | Motivo |
|--------------|--------|
| Tags sem descrição | Tag vazia não comunica problema |
| Descrições vagas | "FIXME: fix this" não explica o que fazer |
| Acumular tags antigas | Tags devem ser resolvidas, não acumuladas |
| Usar para documentação permanente | Tags são temporárias, documentação vai em JSDoc |
| Tags em código crítico de produção | Resolver antes de mergear |
| Múltiplas tags na mesma seção | Indica problema maior, refatorar |

## Rules Relacionadas

- [clean-code/006 - Comment Quality](../clean-code/006_qualidade-comentarios-porque.md): codetags são temporárias
- [clean-code/019 - Boy Scout Rule](../clean-code/019_regra-escoteiro-refatoracao-continua.md): resolver tags ao modificar código
- [clean-code/002 - KISS](../clean-code/002_prioritization-simplicity-clarity.md): muitas tags indica complexidade excessiva

---

**Criada em**: 2026-03-19
**Versão**: 2.0
