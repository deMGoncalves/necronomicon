---
name: react
description: "Padrões de design e renderização React para 2026. Use quando @coder implementa componentes React, ao escolher entre CSR/SSR/SSG/RSC, ou ao aplicar padrões HOC/Hooks/Compound."
model: sonnet
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# React Patterns

Referência de padrões de design e renderização React (2026) baseada em [patterns.dev/react](https://www.patterns.dev/react/).

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Ao implementar componentes React; ao escolher estratégia de renderização (CSR/SSR/SSG/ISR/RSC); ao aplicar padrões HOC/Hooks/Compound em React 18+ |
| **Prerequisites** | JavaScript/TypeScript moderno (ES2022+); conceitos fundamentais de React (componentes, estado, ciclo de vida); para RSC: Next.js 13+ App Router |
| **Constraints** | HOC e Render Props são padrões legados — substituir por Hooks quando possível; não usar CSR para páginas públicas com SEO crítico; não misturar Server/Client Components incorretamente |
| **Scope** | Padrões de design React (HOC, Hooks, Compound, Container/Presentational, Render Props) e estratégias de renderização (CSR, SSR, SSG, ISR, RSC) |

---

## Quando Usar

| Agente | Contexto |
|--------|----------|
| @coder | Ao implementar componentes React, escolher estratégia de renderização |
| @architect | Ao definir arquitetura React (CSR vs SSR vs RSC), decisões de framework |
| @architect | Ao verificar conformidade com padrões modernos React 18+ |

---

## Estrutura de Referência

### Padrões de Design

| Padrão | Quando Usar | Arquivo |
|--------|-------------|---------|
| **HOC** | Reutilização de lógica cross-cutting (legado, preferir Hooks) | `references/hoc.md` |
| **Hooks** | Gerenciamento de estado e ciclo de vida em componentes funcionais | `references/hooks-pattern.md` |
| **Compound** | Componentes que compartilham estado implicitamente | `references/compound.md` |
| **Container/Presentational** | Separar lógica de apresentação (legado, Hooks eliminam necessidade) | `references/container-presentational.md` |
| **Render Props** | Compartilhar lógica via prop funcional (legado, Hooks são mais limpos) | `references/render-props.md` |

### Estratégias de Renderização

| Estratégia | SEO | TTI | Bundle | Quando Usar | Arquivo |
|------------|-----|-----|--------|-------------|---------|
| **CSR** | ❌ | Lento | Grande | Dashboards internos, apps altamente interativos | `references/rendering-overview.md` |
| **SSR** | ✅ | Médio | Grande | Conteúdo dinâmico + SEO crítico | `references/rendering-overview.md` |
| **SSG** | ✅ | Rápido | Médio | Conteúdo estático (blogs, docs) | `references/rendering-overview.md` |
| **ISR** | ✅ | Rápido | Médio | SSG + atualizações incrementais | `references/rendering-overview.md` |
| **RSC** | ✅ | Muito rápido | Pequeno | Reduzir bundle, data-fetching server-side | `references/rendering-overview.md` |

---

## Guia de Decisão Rápida

### Escolhendo Padrão de Design

```
Precisa reutilizar lógica entre componentes?
  ├─ Sim, com estado → use Custom Hook
  ├─ Sim, cross-cutting sem estado → use HOC (legado) ou Custom Hook
  └─ Não → componente funcional simples

Componentes precisam compartilhar estado implícito?
  ├─ Sim → Compound Pattern
  └─ Não → Composição simples com props

Componente precisa renderizar conteúdo flexível?
  ├─ Sim → use children ou Render Props
  └─ Não → componente com interface fixa
```

### Escolhendo Estratégia de Renderização

```
SEO crítico?
  ├─ Não → CSR (Client-Side Rendering)
  └─ Sim
      ├─ Conteúdo estático? → SSG ou ISR
      ├─ Conteúdo dinâmico? → SSR ou RSC
      └─ Performance máxima? → SSR + RSC + Streaming

Tamanho do bundle crítico?
  └─ Sim → RSC (React Server Components)

Interatividade imediata?
  └─ Sim → CSR ou SSR com Selective Hydration
```

---

## Padrões Modernos (React 18+, 2026)

| Padrão | Status | Recomendação |
|--------|--------|--------------|
| **Hooks** | ✅ Moderno | Base fundamental — usar por padrão |
| **RSC** | ✅ Moderno | Production-ready (Next.js 13+ App Router) |
| **Streaming SSR** | ✅ Moderno | Usar com Suspense para performance |
| **Selective Hydration** | ✅ Moderno | React 18+ automático com Suspense |
| **HOC** | ⚠️ Legado | Substituir por Hooks quando possível |
| **Render Props** | ⚠️ Legado | Hooks oferecem alternativa mais limpa |
| **Container/Presentational** | ⚠️ Legado | Hooks eliminam necessidade |

---

## Anti-Padrões (evitar)

### Design
- ❌ HOCs profundamente aninhados ("wrapper hell")
- ❌ Props drilling excessivo (use Context ou gerenciamento de estado)
- ❌ Lógica de negócio em componentes de apresentação
- ❌ Uso excessivo de `useEffect` (React 18+ desencoraja)

### Renderização
- ❌ CSR puro para páginas públicas com SEO
- ❌ SSR sem streaming (lento)
- ❌ Misturar Server/Client Components incorretamente
- ❌ Client Components importando Server Components

---

## Detector de Smell

| Vejo no código | Padrão violado | Ação |
|----------------|----------------|------|
| `withAuth(withLogger(withTheme(Component)))` | HOC hell | Converter para Custom Hooks |
| Props passadas por 5+ níveis | Props drilling | Usar Context API ou Zustand |
| `useEffect` com lógica complexa | Overuse de Effect | Mover para event handlers ou derivar estado |
| Componente com 10+ `useState` | Fragmentação de estado | Usar `useReducer` ou biblioteca de gerenciamento de estado |
| Server Component importado em Client Component | Violação de fronteira RSC | Passar como children ou prop |
| `'use client'` no topo de todo arquivo | Over-clienting | Manter Server Components por padrão |

---

## Justificativa

### Padrões de Design
- `references/hoc.md` — Higher-Order Components (legado)
- `references/hooks-pattern.md` — Hooks Pattern (moderno)
- `references/compound.md` — Compound Pattern
- `references/container-presentational.md` — Container/Presentational (legado)
- `references/render-props.md` — Render Props (legado)

### Estratégias de Renderização
- `references/rendering-overview.md` — Guia completo CSR/SSR/SSG/ISR/RSC

---

## Fluxo de Aplicação

```
1. Identificar o problema (design ou renderização)
2. Consultar o Guia de Decisão Rápida
3. Ler referência relevante
4. Aplicar padrão/estratégia conforme contexto
5. Validar conformidade com regras arquiteturais (rules 010-014)
```

---

**Criada em**: 2026-04-01
**Versão**: 1.0.0
