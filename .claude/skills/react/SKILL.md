---
name: react
description: "Padrões de design e renderização React para 2026. Use quando @developer implementar componentes React, ao escolher entre CSR/SSR/SSG/RSC, ou ao aplicar patterns HOC/Hooks/Compound."
model: sonnet
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# React Patterns

Referência de padrões de design e renderização para React (2026) baseada em [patterns.dev/react](https://www.patterns.dev/react/).

---

## Quando Usar

| Agent | Contexto |
|-------|----------|
| @developer | Ao implementar componentes React, escolher estratégia de renderização |
| @architect | Ao definir arquitetura React (CSR vs SSR vs RSC), decisões de framework |
| @reviewer | Ao verificar conformidade com padrões modernos React 18+ |

---

## Estrutura de Referências

### Design Patterns

| Pattern | Quando Usar | Arquivo |
|---------|-------------|---------|
| **HOC** | Reutilização de lógica cross-cutting (legado, preferir Hooks) | `references/hoc.md` |
| **Hooks** | Gerenciamento de estado e lifecycle em componentes funcionais | `references/hooks-pattern.md` |
| **Compound** | Componentes que compartilham estado implicitamente | `references/compound.md` |
| **Container/Presentational** | Separar lógica de apresentação (legado, Hooks eliminam necessidade) | `references/container-presentational.md` |
| **Render Props** | Compartilhar lógica via prop funcional (legado, Hooks são mais limpos) | `references/render-props.md` |

### Rendering Strategies

| Strategy | SEO | TTI | Bundle | Quando Usar | Arquivo |
|----------|-----|-----|--------|-------------|---------|
| **CSR** | ❌ | Lento | Grande | Dashboards internos, apps altamente interativos | `references/rendering-overview.md` |
| **SSR** | ✅ | Médio | Grande | Conteúdo dinâmico + SEO crítico | `references/rendering-overview.md` |
| **SSG** | ✅ | Rápido | Médio | Conteúdo estático (blogs, docs) | `references/rendering-overview.md` |
| **ISR** | ✅ | Rápido | Médio | SSG + atualizações incrementais | `references/rendering-overview.md` |
| **RSC** | ✅ | Muito rápido | Pequeno | Reduzir bundle, data-fetching server-side | `references/rendering-overview.md` |

---

## Quick Decision Guide

### Escolher Padrão de Design

```
Preciso reutilizar lógica entre componentes?
  ├─ Sim, com estado → usar Custom Hook
  ├─ Sim, cross-cutting sem estado → usar HOC (legado) ou Custom Hook
  └─ Não → componente simples funcional

Componentes precisam compartilhar estado implícito?
  ├─ Sim → Compound Pattern
  └─ Não → Composição simples com props

Componente precisa renderizar conteúdo flexível?
  ├─ Sim → usar children ou Render Props
  └─ Não → componente com interface fixa
```

### Escolher Estratégia de Renderização

```
SEO crítico?
  ├─ Não → CSR (Client-Side Rendering)
  └─ Sim
      ├─ Conteúdo estático? → SSG ou ISR
      ├─ Conteúdo dinâmico? → SSR ou RSC
      └─ Máxima performance? → SSR + RSC + Streaming

Bundle size crítico?
  └─ Sim → RSC (React Server Components)

Interatividade imediata?
  └─ Sim → CSR ou SSR com Selective Hydration
```

---

## Padrões Modernos (React 18+, 2026)

| Pattern | Status | Recomendação |
|---------|--------|--------------|
| **Hooks** | ✅ Moderno | Base fundamental — usar por padrão |
| **RSC** | ✅ Moderno | Production-ready (Next.js 13+ App Router) |
| **Streaming SSR** | ✅ Moderno | Usar com Suspense para performance |
| **Selective Hydration** | ✅ Moderno | React 18+ automático com Suspense |
| **HOC** | ⚠️ Legado | Substituir por Hooks quando possível |
| **Render Props** | ⚠️ Legado | Hooks oferecem alternativa mais limpa |
| **Container/Presentational** | ⚠️ Legado | Hooks eliminam necessidade |

---

## Anti-Patterns (evitar)

### Design
- ❌ HOCs aninhados profundamente ("wrapper hell")
- ❌ Props drilling excessivo (usar Context ou state management)
- ❌ Lógica de negócio em componentes de apresentação
- ❌ Uso excessivo de `useEffect` (React 18+ desencoraja)

### Rendering
- ❌ CSR puro para páginas públicas com SEO
- ❌ SSR sem streaming (lento)
- ❌ Misturar Server/Client Components incorretamente
- ❌ Client Components importando Server Components

---

## Smell Detector

| Vejo no código | Pattern violado | Ação |
|----------------|-----------------|------|
| `withAuth(withLogger(withTheme(Component)))` | HOC hell | Converter para Custom Hooks |
| Props passadas por 5+ níveis | Props drilling | Usar Context API ou Zustand |
| `useEffect` com lógica complexa | Effect overuse | Mover para event handlers ou derivar estado |
| Componente com 10+ `useState` | State fragmentation | Usar `useReducer` ou state management library |
| Server Component importado em Client Component | RSC boundary violation | Passar como children ou prop |
| `'use client'` no topo de todo arquivo | Over-clienting | Manter Server Components por padrão |

---

## Fundamentação

### Design Patterns
- `references/hoc.md` — Higher-Order Components (legado)
- `references/hooks-pattern.md` — Hooks Pattern (moderno)
- `references/compound.md` — Compound Pattern
- `references/container-presentational.md` — Container/Presentational (legado)
- `references/render-props.md` — Render Props (legado)

### Rendering Strategies
- `references/rendering-overview.md` — Guia completo CSR/SSR/SSG/ISR/RSC

---

## Workflow de Aplicação

```
1. Identifique o problema (design ou rendering)
2. Consulte o Quick Decision Guide
3. Leia referência relevante
4. Aplique pattern/strategy conforme contexto
5. Valide conformidade com regras arquiteturais (rules 010-014)
```

---

**Criada em**: 2026-04-01
**Versão**: 1.0.0
