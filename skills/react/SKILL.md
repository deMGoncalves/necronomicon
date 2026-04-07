---
name: react
description: "React design and rendering patterns for 2026. Use when @developer implements React components, when choosing between CSR/SSR/SSG/RSC, or when applying HOC/Hooks/Compound patterns."
model: sonnet
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# React Patterns

Reference for React design and rendering patterns (2026) based on [patterns.dev/react](https://www.patterns.dev/react/).

---

## When to Use

| Agent | Context |
|-------|---------|
| @developer | When implementing React components, choosing rendering strategy |
| @architect | When defining React architecture (CSR vs SSR vs RSC), framework decisions |
| @reviewer | When verifying compliance with modern React 18+ patterns |

---

## Reference Structure

### Design Patterns

| Pattern | When to Use | File |
|---------|-------------|------|
| **HOC** | Cross-cutting logic reuse (legacy, prefer Hooks) | `references/hoc.md` |
| **Hooks** | State and lifecycle management in functional components | `references/hooks-pattern.md` |
| **Compound** | Components that share state implicitly | `references/compound.md` |
| **Container/Presentational** | Separate logic from presentation (legacy, Hooks eliminate need) | `references/container-presentational.md` |
| **Render Props** | Share logic via functional prop (legacy, Hooks are cleaner) | `references/render-props.md` |

### Rendering Strategies

| Strategy | SEO | TTI | Bundle | When to Use | File |
|----------|-----|-----|--------|-------------|------|
| **CSR** | ❌ | Slow | Large | Internal dashboards, highly interactive apps | `references/rendering-overview.md` |
| **SSR** | ✅ | Medium | Large | Dynamic content + critical SEO | `references/rendering-overview.md` |
| **SSG** | ✅ | Fast | Medium | Static content (blogs, docs) | `references/rendering-overview.md` |
| **ISR** | ✅ | Fast | Medium | SSG + incremental updates | `references/rendering-overview.md` |
| **RSC** | ✅ | Very fast | Small | Reduce bundle, server-side data-fetching | `references/rendering-overview.md` |

---

## Quick Decision Guide

### Choosing Design Pattern

```
Need to reuse logic between components?
  ├─ Yes, with state → use Custom Hook
  ├─ Yes, cross-cutting without state → use HOC (legacy) or Custom Hook
  └─ No → simple functional component

Components need to share implicit state?
  ├─ Yes → Compound Pattern
  └─ No → Simple composition with props

Component needs to render flexible content?
  ├─ Yes → use children or Render Props
  └─ No → component with fixed interface
```

### Choosing Rendering Strategy

```
SEO critical?
  ├─ No → CSR (Client-Side Rendering)
  └─ Yes
      ├─ Static content? → SSG or ISR
      ├─ Dynamic content? → SSR or RSC
      └─ Maximum performance? → SSR + RSC + Streaming

Bundle size critical?
  └─ Yes → RSC (React Server Components)

Immediate interactivity?
  └─ Yes → CSR or SSR with Selective Hydration
```

---

## Modern Patterns (React 18+, 2026)

| Pattern | Status | Recommendation |
|---------|--------|----------------|
| **Hooks** | ✅ Modern | Fundamental base — use by default |
| **RSC** | ✅ Modern | Production-ready (Next.js 13+ App Router) |
| **Streaming SSR** | ✅ Modern | Use with Suspense for performance |
| **Selective Hydration** | ✅ Modern | React 18+ automatic with Suspense |
| **HOC** | ⚠️ Legacy | Replace with Hooks when possible |
| **Render Props** | ⚠️ Legacy | Hooks offer cleaner alternative |
| **Container/Presentational** | ⚠️ Legacy | Hooks eliminate need |

---

## Anti-Patterns (avoid)

### Design
- ❌ Deeply nested HOCs ("wrapper hell")
- ❌ Excessive props drilling (use Context or state management)
- ❌ Business logic in presentational components
- ❌ Excessive use of `useEffect` (React 18+ discourages)

### Rendering
- ❌ Pure CSR for public pages with SEO
- ❌ SSR without streaming (slow)
- ❌ Incorrectly mixing Server/Client Components
- ❌ Client Components importing Server Components

---

## Smell Detector

| I see in code | Violated pattern | Action |
|---------------|------------------|--------|
| `withAuth(withLogger(withTheme(Component)))` | HOC hell | Convert to Custom Hooks |
| Props passed through 5+ levels | Props drilling | Use Context API or Zustand |
| `useEffect` with complex logic | Effect overuse | Move to event handlers or derive state |
| Component with 10+ `useState` | State fragmentation | Use `useReducer` or state management library |
| Server Component imported in Client Component | RSC boundary violation | Pass as children or prop |
| `'use client'` at top of every file | Over-clienting | Keep Server Components by default |

---

## Rationale

### Design Patterns
- `references/hoc.md` — Higher-Order Components (legacy)
- `references/hooks-pattern.md` — Hooks Pattern (modern)
- `references/compound.md` — Compound Pattern
- `references/container-presentational.md` — Container/Presentational (legacy)
- `references/render-props.md` — Render Props (legacy)

### Rendering Strategies
- `references/rendering-overview.md` — Complete guide CSR/SSR/SSG/ISR/RSC

---

## Application Workflow

```
1. Identify the problem (design or rendering)
2. Consult the Quick Decision Guide
3. Read relevant reference
4. Apply pattern/strategy according to context
5. Validate compliance with architectural rules (rules 010-014)
```

---

**Created on**: 2026-04-01
**Version**: 1.0.0
