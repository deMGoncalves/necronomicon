---
name: codetags
description: Convenção para marcação de código com tags de comentário padronizadas. Use quando @architect identificar violações no código e precisar anotá-las com marcadores padronizados, ao registrar débito técnico, bugs ou otimizações pendentes com rastreabilidade.
model: sonnet
allowed-tools: Read, Edit, Grep, Glob
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Codetags

Convenção para marcação de código com tags de comentário padronizadas para gerenciar débito técnico, facilitar buscas e manter rastreabilidade de problemas diretamente no código-fonte.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Quando @architect identifica violações de regras durante revisão; ao registrar débito técnico, bugs conhecidos, otimizações pendentes ou problemas de segurança |
| **Prerequisites** | Identificação da violação específica e da rule correspondente; referência às 16 tags disponíveis em `references/tags-reference.md` |
| **Constraints** | Uma tag por violação; nunca criar tag sem descrição; FIXME reservado para violações críticas; não usar para substituir correção imediata quando possível |
| **Scope** | Inserção de comentários padronizados com formato `// TAG(rule-id): descrição` na linha acima da seção problemática em qualquer arquivo de código-fonte |

---

## Quando Usar

Use quando o revisor identificar violações no código e precisar anotar seções com marcadores padronizados, ou quando quiser marcar manualmente seções que necessitam atenção futura.

## Princípio

| Princípio | Descrição |
|-----------|-------------|
| Ensinar | Cada marcação explica o porquê do problema e o caminho para melhorar |
| Busca fácil | Tags padronizadas permitem busca global por tipo de problema |
| Ação clara | Cada tag indica o tipo de ação necessária |
| Tom de parceiro | Escrever como um colega ensinando, não como sistema de auditoria |

→ Veja [references/tags-reference.md](references/tags-reference.md) — índice de 16 tags organizadas por severidade (🔴🟠🟡🟢), com link para arquivo individual de cada tag.

## Formato de Marcação

```typescript
// TAG(rule-id): descrição
```

→ Veja [references/reviewer-mapping.md](references/reviewer-mapping.md) para mapeamento de severidade para tag.

## Regras de Aplicação

| Regra | Descrição |
|------|-------------|
| Uma tag por violação | Cada violação recebe exatamente uma marcação |
| Linha acima | Tag é inserida na linha imediatamente acima da seção violada |
| Sem duplicação | Se tag já existe na seção, atualizar ao invés de adicionar nova |
| Explicar impacto | Descrever o que pode dar errado por causa do problema — não apenas o sintoma |
| Descrição concisa | Máximo uma linha com problema e sugestão de correção |

## Exemplos

```typescript
// ❌ Bad — comentário livre, vago, não ensina nada
// TODO: fix this later
// fix: validation doesn't work
function calculateDiscount(amount: number) {
  return amount * 0.1  // this is wrong
}

// ✅ Good — codetag que explica por quê e guia melhoria
// TODO: Esta função aceita qualquer número, incluindo negativos e zero.
// Isso pode causar descontos incorretos em casos extremos. Adicionar validação
// no início garante que o cálculo só acontece com dados válidos.
//
// FIXME: O valor 0.1 não comunica o que representa. Extrair para
// uma constante nomeada (ex: DEFAULT_DISCOUNT_RATE) torna código mais legível
// e facilita ajustar taxa no futuro sem caçar número no código.
function calculateDiscount(amount: number) {
  return amount * 0.1
}
```

## Proibições

| O que evitar | Razão |
|---------------|--------|
| Tags sem descrição | Tag vazia não comunica problema |
| Múltiplas tags na mesma seção | Escolher tag mais relevante para violação principal |
| Codetag sem explicação do porquê | Comentário que não ensina não ajuda dev a crescer |
| FIXME para problemas menores | Reservar FIXME para violações críticas reais |
| TODO sem ação clara | Descrição deve indicar o que precisa ser feito |

## Fluxo de Aplicação

| Passo | Ação |
|------|--------|
| 1 | Receber relatório do revisor ou identificar violação |
| 2 | Localizar linha exata da violação no arquivo |
| 3 | Selecionar tag apropriada segundo mapeamento de severidade |
| 4 | Inserir comentário na linha acima da seção com formato padronizado |
| 5 | Verificar que não há tag duplicada na mesma seção |

## Justificativa

- [026 - Qualidade de Comentários](../../rules/026_qualidade-comentarios-porque.md): tags explicam porquê da marcação, não o que código faz
- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): marcações claras facilitam identificação de débito técnico
- [039 - Regra do Escoteiro](../../rules/039_regra-escoteiro-refatoracao-continua.md): tags guiam refatoração contínua indicando onde melhorar
- [010 - Princípio da Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md): cada tag tem responsabilidade clara de comunicação
- [024 - Proibição de Constantes Mágicas](../../rules/024_proibicao-constantes-magicas.md): tags padronizadas eliminam marcações ad-hoc sem padrão

**Skills relacionadas:**
- [`software-quality`](../software-quality/SKILL.md) — complementa: fatores McCall determinam severidade de codetag (Integrity → FIXME, Efficiency → OPTIMIZE)
- [`anti-patterns`](../anti-patterns/SKILL.md) — reforça: codetags são o mecanismo para anotar violações de anti-patterns
