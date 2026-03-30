---
name: codetags
description: Convenção de marcação de código com comment tags padronizadas. Use quando precisar anotar trechos de código com marcadores de débito técnico, correções pendentes ou observações.
model: sonnet
allowed-tools: Read, Edit, Grep, Glob
user-invocable: true
location: managed
---

# Codetags

Convenção de marcação de código com comment tags padronizadas para gerenciar débito técnico, facilitar buscas e manter rastreabilidade de problemas diretamente no código-fonte.

---

## Quando Usar

Use quando o reviewer identificar violações no código e precisar anotar os trechos com marcadores padronizados, ou quando quiser marcar manualmente trechos que precisam de atenção futura.

## Princípio

| Princípio | Descrição |
|-----------|-----------|
| Rastreabilidade | Cada marcação vincula o trecho a uma regra ou skill violada |
| Busca facilitada | Tags padronizadas permitem busca global por tipo de problema |
| Ação clara | Cada tag indica o tipo de ação necessária |

## Tags Disponíveis

| Tag | Significado | Quando Usar |
|-----|-------------|-------------|
| FIXME | Corrigir | Código quebrado, incorreto ou inseguro que precisa de correção urgente |
| TODO | A fazer | Pendência funcional ou melhoria planejada que precisa ser implementada |
| HACK | Gambiarra | Solução temporária que funciona mas não é ideal, indica necessidade de refatoração |
| BUG | Erro | Vincular trecho a um bug rastreado com número de ticket |
| XXX | Atenção | Área questionável que merece atenção, menos urgente que FIXME |
| NOTE | Nota | Observação importante sobre decisão ou contexto não óbvio |
| OPTIMIZE | Performance | Código funcional mas ineficiente que pode ser otimizado |
| REVIEW | Revisar | Trecho que precisa de revisão para confirmar se está correto |

## Formato da Marcação

| Aspecto | Formato |
|---------|---------|
| Estrutura | `// TAG(rule-id): descrição` |
| Com ticket | `// BUG(#1234): descrição do problema` |
| Sem rule | `// TAG: descrição` |
| Posição | Linha imediatamente acima do trecho marcado |

## Mapeamento Reviewer para Tags

| Severidade Reviewer | Tag | Critério |
|---------------------|-----|----------|
| Crítica | FIXME | Violação que bloqueia aprovação |
| Alta | TODO | Violação que precisa ser corrigida |
| Média | XXX | Violação que merece atenção |
| Performance (CC alto) | OPTIMIZE | Complexidade ciclomática acima do ideal |
| Performance (Big-O) | OPTIMIZE | Complexidade algorítmica O(n^2) ou pior conforme skill bigo |
| Solução temporária | HACK | Workaround detectado no código |
| Observação arquitetural | NOTE | Contexto relevante sobre decisão |

## Regras de Aplicação

| Regra | Descrição |
|-------|-----------|
| Uma tag por violação | Cada violação recebe exatamente uma marcação |
| Linha acima | A tag é inserida na linha imediatamente acima do trecho violado |
| Não duplicar | Se já existe tag no trecho, atualizar ao invés de adicionar nova |
| Incluir rule-id | Sempre vincular à regra ou skill violada quando aplicável |
| Descrição concisa | Máximo uma linha com o problema e a correção sugerida |

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Tags sem descrição | Tag vazia não comunica o problema |
| Múltiplas tags no mesmo trecho | Escolher a tag mais relevante para a violação principal |
| Tags genéricas sem rule-id | Perdem rastreabilidade com as regras arquiteturais |
| FIXME para problemas menores | Reservar FIXME para violações críticas reais |
| TODO sem ação clara | A descrição deve indicar o que precisa ser feito |

## Fluxo de Aplicação

| Passo | Ação |
|-------|------|
| 1 | Receber relatório do reviewer ou identificar violação |
| 2 | Localizar linha exata da violação no arquivo |
| 3 | Selecionar tag apropriada conforme mapeamento de severidade |
| 4 | Inserir comentário na linha acima do trecho com formato padronizado |
| 5 | Verificar se não há duplicata de tag no mesmo trecho |

## Fundamentação

- [026 - Qualidade de Comentários](../../rules/026_qualidade-comentarios-porque.md): tags explicam o porquê da marcação, não o que o código faz
- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): marcações claras facilitam identificação de débito técnico
- [039 - Regra do Escoteiro](../../rules/039_regra-escoteiro-refatoracao-continua.md): tags guiam a refatoração contínua indicando onde melhorar
- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): cada tag tem uma responsabilidade clara de comunicação
- [024 - Proibição de Constantes Mágicas](../../rules/024_proibicao-constantes-magicas.md): tags padronizadas eliminam marcações ad-hoc sem padrão
