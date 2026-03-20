---
titulo: Regra do Escoteiro Aplicada à Refatoração Contínua
aliases:
  - Boy Scout Rule
tipo: rule
id: CC-19
severidade: 🟡 Médio
origem: clean-code
tags:
  - clean-code
  - comportamental
  - refatoracao
resolver: Próxima iteração
relacionados:
  - "[[priorizacao-simplicidade-clareza]]"
  - "[[proibicao-anti-padrao-blob]]"
criado: 2025-10-08
---

# Regra do Escoteiro Aplicada à Refatoração Contínua (Boy Scout Rule)

*Boy Scout Rule*


---

## Definição

Obriga o desenvolvedor a **sempre deixar o código melhor do que encontrou** (*Boy Scout Rule*). Mesmo que uma alteração seja pequena, o desenvolvedor deve aproveitar a oportunidade para corrigir pequenos *code smells* próximos ao local de trabalho.

## Motivação

Este princípio encoraja a **refatoração contínua e emergente**, prevenindo o acúmulo de pequenas dívidas técnicas. É fundamental para manter a manutenibilidade a longo prazo e reduzir a incidência do Anti-Pattern The Blob.

## Quando Aplicar

- [ ] Pequenos *code smells* (ex.: nomes de variáveis ruins, ausência de *guard clause*) encontrados no escopo da alteração devem ser corrigidos.
- [ ] Arquivos sendo modificados que violam `STRUCTURAL-022` (Complexidade Ciclomática > 5) devem ser refatorados para um nível inferior.
- [ ] O *diff* do *Pull Request* deve evidenciar melhorias de qualidade, mesmo que não solicitadas.

## Quando NÃO Aplicar

- **Alterações de Emergência**: *Hotfixes* críticos em produção onde o risco de refatoração supera o ganho imediato de qualidade.

## Violação — Exemplo

```javascript
// ❌ Desenvolvedor corrige bug mas ignora code smell evidente ao redor
function processPayment(o, f) {           // nomes péssimos — oportunidade ignorada
  if (f == true) {                        // == em vez de === — oportunidade ignorada
    // FIXME: bug corrigido aqui
    return o.total * 0.9;
  }
  return o.total;
}
```

## Conformidade — Exemplo

```javascript
// ✅ Corrigiu o bug E melhorou o que estava ao redor
function processPayment(order, applyDiscount) {   // nomes revelam intenção
  if (applyDiscount === true) {                   // === estrito
    // bug corrigido: desconto aplicado sobre subtotal, não total
    return order.subtotal * 0.9;
  }
  return order.total;
}
```

## Anti-Patterns Relacionados

- **Technical Debt Accumulation** — ignorar oportunidades de melhoria em cada commit
- **Scope Creep** — o oposto: refatorar tanto que o PR perde foco

## Como Detectar

### Manual

Code review: Verificar se o desenvolvedor apenas corrigiu o bug, ou se melhorou a qualidade do código ao redor.

### Automático

Análise de commits: Verificar se a refatoração está sendo feita em pequenas doses.

## Relação com ICP

Reduz gradualmente todos os componentes do ICP ao longo do tempo: **CC_base** (eliminar ramificações desnecessárias), **Aninhamento** (adicionar guard clauses), **Responsabilidades** (extrair funções) e **Acoplamento** (remover dependências não utilizadas).

## Relacionados

- [[priorizacao-simplicidade-clareza]] — reforça
- [[proibicao-anti-padrao-blob]] — complementa
