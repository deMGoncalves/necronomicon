---
name: codetags
description: Convenção de marcação de código com comment tags padronizadas. Use quando o @reviewer identificar violações no código e precisar anotá-las com marcadores padronizados, ao registrar débito técnico, bugs ou otimizações pendentes com rastreabilidade.
model: sonnet
allowed-tools: Read, Edit, Grep, Glob
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Codetags

Convenção de marcação de código com comment tags padronizadas para gerenciar débito técnico, facilitar buscas e manter rastreabilidade de problemas diretamente no código-fonte.

---

## Quando Usar

Use quando o reviewer identificar violações no código e precisar anotar os trechos com marcadores padronizados, ou quando quiser marcar manualmente trechos que precisam de atenção futura.

## Princípio

| Princípio | Descrição |
|-----------|-----------|
| Ensinar | Cada marcação explica o porquê do problema e o caminho para melhorar |
| Busca facilitada | Tags padronizadas permitem busca global por tipo de problema |
| Ação clara | Cada tag indica o tipo de ação necessária |
| Tom parceiro | Escreva como um colega ensinando, não como um sistema de auditoria |

→ Consulte [references/tags-reference.md](references/tags-reference.md) — índice das 16 tags organizadas por severidade (🔴🟠🟡🟢), com link para o arquivo individual de cada tag.

## Formato da Marcação

```typescript
// TAG(rule-id): descrição
```

→ Consulte [references/reviewer-mapping.md](references/reviewer-mapping.md) para mapeamento de severidades para tags.

## Regras de Aplicação

| Regra | Descrição |
|-------|-----------|
| Uma tag por violação | Cada violação recebe exatamente uma marcação |
| Linha acima | A tag é inserida na linha imediatamente acima do trecho violado |
| Não duplicar | Se já existe tag no trecho, atualizar ao invés de adicionar nova |
| Explicar o impacto | Descreva o que pode dar errado por causa do problema — não apenas o sintoma |
| Descrição concisa | Máximo uma linha com o problema e a correção sugerida |

## Exemplos

```typescript
// ❌ Ruim — comentário livre, vago, sem ensinar nada
// TODO: arrumar isso depois
// fix: validação não funciona
function calculateDiscount(amount: number) {
  return amount * 0.1  // isso tá errado
}

// ✅ Bom — codetag que explica o porquê e orienta a melhoria
// TODO: Esta função aceita qualquer número, incluindo negativos e zero.
// Isso pode causar descontos incorretos em casos de borda. Adicionar
// validação no início garante que o cálculo só acontece com dados válidos.
//
// FIXME: O valor 0.1 não comunica o que representa. Extrair para uma
// constante nomeada (ex: DEFAULT_DISCOUNT_RATE) deixa o código mais legível
// e facilita ajustar a taxa no futuro sem precisar caçar o número no código.
function calculateDiscount(amount: number) {
  return amount * 0.1
}
```

## Proibições

| O que evitar | Razão |
|--------------|-------|
| Tags sem descrição | Tag vazia não comunica o problema |
| Múltiplas tags no mesmo trecho | Escolher a tag mais relevante para a violação principal |
| Codetag sem explicação do porquê | Um comentário que não ensina não ajuda o dev a crescer |
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

**Skills relacionadas:**
- [`software-quality`](../software-quality/SKILL.md) — complementa: fatores McCall determinam a severidade da codetag (Integrity → FIXME, Efficiency → OPTIMIZE)
- [`anti-patterns`](../anti-patterns/SKILL.md) — reforça: codetags são o mecanismo para anotar violações de anti-patterns
