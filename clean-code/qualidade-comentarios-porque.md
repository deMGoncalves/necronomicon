---
titulo: "Qualidade de Comentários: Apenas o Porquê, Não o Quê"
aliases:
  - Comment Quality
tipo: rule
id: CC-06
severidade: 🟡 Médio
origem: clean-code
tags:
  - clean-code
  - estrutural
  - nomenclatura
resolver: Próxima iteração
relacionados:
  - "[[006_proibicao-nomes-abreviados]]"
  - "[[priorizacao-simplicidade-clareza]]"
  - "[[011_logs-fluxo-eventos]]"
criado: 2025-10-08
---

# Qualidade de Comentários: Apenas o Porquê, Não o Quê (Comment Quality)

*Comment Quality*


---

## Definição

Requer que comentários expliquem o **porquê** ou a **intenção** do código, o contexto legal, os trade-offs ou a lógica não óbvia, e **proíbe** comentários redundantes que descrevem o que o código já evidencia.

## Motivação

Comentários redundantes poluem o código e tendem a ficar desatualizados, criando mentiras no sistema. Força que o código seja autodocumentado por meio de boas nomenclaturas.

## Quando Aplicar

- [ ] É proibido usar comentários para descrever o que uma função óbvia faz (ex.: `// retorna o valor`).
- [ ] Comentários devem ser usados para explicar regras de negócio não evidentes, trade-offs de desempenho ou correções específicas de bugs.
- [ ] Funções públicas devem ter no máximo **20%** de seu corpo ocupado por linhas de comentário.

## Quando NÃO Aplicar

- **Documentação de API**: Comentários JSDoc ou TSDoc usados para gerar documentação de interfaces públicas.
- **Marcadores Especiais**: Comentários como `// TODO:` ou `// FIXME:` (em quantidade limitada).

## Violação — Exemplo

```javascript
// ❌ Comentários descrevem o QUÃO óbvio — ruído puro
function getUser(id) {
  // busca o usuário pelo id
  const user = db.find(id);
  // retorna o usuário
  return user;
}
```

## Conformidade — Exemplo

```javascript
// ✅ Comentário explica o PORQUÊ — contexto que o código não pode expressar
function getUser(id) {
  // Busca por ID string por compatibilidade com a API legada v1 que não usa UUIDs
  return db.find(String(id));
}
```

## Anti-Patterns Relacionados

- **Redundant Comments** — comentários que apenas repetem o que o código diz
- [[lava-flow|Zombie Code]] — código comentado que nunca é removido

## Como Detectar

### Manual

Verificar se o código pode ser lido e compreendido sem precisar ler os comentários.

### Automático

Biome: sem regra nativa para qualidade de comentários; verificar manualmente se comentários descrevem o *quê* em vez do *porquê*.

## Relação com ICP

Impacto indireto: código que precisa de comentários para explicar *o quê* geralmente tem [[componente-cc-base|CC]] alto ou nomes ruins — sintomas de [[calculo-icp|ICP]] elevado. Comentários não reduzem o ICP, mas sua ausência (no caso correto) indica código autodocumentado com ICP baixo.

## Relacionados

- [[006_proibicao-nomes-abreviados|Proibição de Nomes Abreviados]] — reforça
- [[priorizacao-simplicidade-clareza]] — complementa
- [[011_logs-fluxo-eventos|Logs como Fluxo de Eventos]] — complementa
