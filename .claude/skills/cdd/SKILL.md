---
name: cdd
description: "Metodologia CDD (Cognitive-Driven Development) para medir carga cognitiva via ICP. Use quando @reviewer avaliar complexidade, calcular ICP por componente, ou calibrar severidade de violações."
model: sonnet
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

## Quando Usar

Use CDD quando precisar:
- **Calcular ICP** de um método/função para quantificar carga cognitiva
- **Avaliar severidade** de violações de rules em code review
- **Calibrar decisões** de aprovação/rejeição de PR com contexto objetivo
- **Identificar hot spots** de complexidade para refatoração prioritária

Triggers específicos:
- @reviewer analisa PR com métodos > 10 linhas ou aninhamento visível
- Developer pede avaliação de complexidade de código legado
- Discussão sobre "esse código está complexo" sem métrica objetiva
- Necessidade de priorizar refatoração entre múltiplos candidatos

---

## A Métrica ICP

ICP (Intrinsic Complexity Points) quantifica carga cognitiva via 4 componentes aditivos:

```
ICP = CC_base + Aninhamento + Responsabilidades + Acoplamento
```

**Limites de ação:**
- ICP ≤ 3: 🟢 Excelente — manter
- ICP 4–6: 🟡 Aceitável — considerar refatoração
- ICP 7–10: 🟠 Preocupante — refatorar antes de nova feature
- ICP > 10: 🔴 Crítico — refatoração obrigatória

**Meta de projeto:** ICP médio ≤ 4, 0% dos métodos com ICP > 10.

---

## Processo de Code Review CDD (3 Passos)

### Passo 1 — Varredura Rápida (2–5min)

Identificar candidatos a ICP alto:
- Arquivos/funções com > 20 linhas
- Aninhamento visível de 3+ níveis
- Anti-patterns óbvios (The Blob, Pyramid of Doom)

### Passo 2 — Análise Profunda (10–20min)

Para cada candidato:
1. **Calcular ICP** (ver `references/icp-formula.md`)
2. **Verificar rules** críticas (eval, return null, imports relativos)
3. **Comentar objetivamente** no PR com ICP + rule violada

### Passo 3 — Calibração Contextual (5min)

Decidir ação com base em contexto:

| ICP | Contexto | Ação |
|-----|----------|------|
| ≤ 5 | Qualquer | ✅ Aprovar |
| 6–7 | Feature normal | 🔄 Pedir refatoração |
| 6–7 | Hotfix crítico | ✅ Aprovar + dívida técnica |
| 8–10 | Qualquer | 🔄 Pedir refatoração |
| > 10 | Qualquer | 🚫 Bloquear |

---

## Componentes ICP

Detalhes completos nos arquivos de referência:

- **[[cc-base.md]]** — Complexidade Ciclomática (caminhos de execução)
- **[[nesting.md]]** — Profundidade de aninhamento (guard clauses)
- **[[responsibilities.md]]** — Número de responsabilidades (8 dimensões)
- **[[coupling.md]]** — Dependências externas diretas
- **[[icp-formula.md]]** — Fórmula completa + tabelas de pontuação

---

## Exemplo de Cálculo ICP

```typescript
// Função candidata
async function processPayment(order) {
  if (!order.isPaid) {                              // +1 CC
    const result = paymentGateway.charge(order.total);  // +1 dependência
    if (result.success) {                           // +1 CC, nível 2 de aninhamento
      order.markAsPaid();
      emailService.sendReceipt(order.email);        // +1 dependência
      return true;
    }
  }
  return false;
}
```

**Cálculo:**
- CC = 3 (2 ifs + 1) → CC_base = 1
- Aninhamento = 2 níveis → +1 ponto
- Responsabilidades = 3 (validação, pagamento, notificação) → +1 ponto
- Acoplamento = 3 (paymentGateway, order, emailService) → +1 ponto
- **ICP Total = 4** 🟡 (aceitável)

---

## Proibições

- Não calcular ICP sem ler o código
- Não bloquear PR por ICP 6–7 sem considerar contexto (hotfix, cobertura de testes)
- Não ignorar ICP > 10 mesmo em código legado
- Não calcular ICP manualmente — use fórmula + tabelas de referência
- Não focar em estilo/formatação enquanto ICP alto é ignorado

---

## Fundamentação

**Rules relacionadas:**
- [Rule 001](../../rules/001_nivel-unico-indentacao.md): CC_base e aninhamento — reforça
- [Rule 010](../../rules/010_principio-responsabilidade-unica.md): responsabilidades — reforça
- [Rule 014](../../rules/014_principio-inversao-dependencia.md): acoplamento — reforça
- [Rule 018](../../rules/018_principio-dependencias-aciclicas.md): acoplamento — reforça
- [Rule 022](../../rules/022_priorizacao-simplicidade-clareza.md): CC ≤ 5 — reforça
- [Rule 066](../../rules/066_proibicao-piramide-do-destino.md): aninhamento — reforça

**Skills relacionadas:**
- [`complexity`](../complexity/SKILL.md) — reforça: complexity mede CC_base que CDD usa para ICP
- [`software-quality`](../software-quality/SKILL.md) — complementa: qualidade de software inclui testability e maintainability que CDD quantifica

**Teoria da Carga Cognitiva (John Sweller, 1988):**
- Memória de trabalho processa 7±2 chunks (Miller, 1956)
- Em manipulação ativa: **4±1 elementos** (refinamento contemporâneo)
- Código com ICP > 5 excede capacidade da memória de trabalho
- Consequência: desenvolvedor constrói modelo mental incorreto → bugs

**Evidência empírica (Zup Innovation, 2020):**
- Times com ICP médio ≤ 4: 40% menos bugs de regressão
- Código com ICP ≤ 3: velocidade de modificação 2.5x maior
- ICP > 10: tempo de debugging 4x maior que ICP ≤ 5

**Referências:**
- [Cognitive-Driven Development (CDD)](https://zup.com.br/blog/cognitive-driven-development-cdd/) — Zup Innovation
- [The Magical Number Seven, Plus or Minus Two](https://en.wikipedia.org/wiki/The_Magical_Number_Seven,_Plus_or_Minus_Two) — George Miller (1956)
- [Cognitive Load Theory](https://en.wikipedia.org/wiki/Cognitive_load) — John Sweller (1988)
