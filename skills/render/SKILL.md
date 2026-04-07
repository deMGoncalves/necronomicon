---
name: render
description: Convention for component rendering and re-rendering — when implementing component rendering, optimizing re-renders, or reviewing code that updates the DOM inefficiently
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Render

Convention for component rendering and re-rendering focused on performance and optimization.

---

## When to Use

Use when creating visual components that need to render HTML and CSS, or when needing to re-render components after state changes.

## Principle

| Principle | Description |
|-----------|-------------|
| Performance | Minimize DOM operations by choosing adequate strategy |
| Reactivity | Re-render only when necessary and optimized |

## Rendering Decorators

| Decorator | Scope | What it renders | Performance | Usage |
|-----------|-------|-----------------|-------------|-------|
| paint | Class | Initial HTML + CSS | N/A | Initial rendering on connected |
| repaint | Setter/Method | Complete HTML + CSS | Expensive | Changes affecting HTML template |
| retouch | Setter/Method | CSS only | Optimized | Changes affecting only styles |

## Paint (Initial Rendering)

| Aspect | Description |
|--------|-------------|
| Application | Class decorator |
| Parameters | component function and style function |
| Execution | When component is connected to DOM |
| Frequency | Once in lifecycle |
| Lifecycle | Executes in connected callback |

## Repaint (Complete Re-rendering)

| Aspect | Description |
|--------|-------------|
| Application | Setter or method decorator |
| What it does | Re-renders HTML and CSS |
| Callbacks | willPaint → html + css → didPaint |
| Async | Uses setImmediate to not block |
| Guard | Checks isPainted before executing |
| Cost | High - reprocesses template and styles |

## Retouch (Partial Re-rendering)

| Aspect | Description |
|--------|-------------|
| Application | Setter or method decorator |
| What it does | Re-renders CSS only |
| Callbacks | Only cssCallback |
| Async | Uses setImmediate to not block |
| Guard | Checks isPainted before executing |
| Cost | Low - only recalculates styles |

## When to Use Each Decorator

| Situation | Decorator | Justification |
|-----------|-----------|---------------|
| Change of src, use, fallback | repaint | HTML content changes |
| Change of color, size, variant | retouch | Only styles change |
| Change of internal text | repaint | HTML template changes |
| Change of CSS class | retouch | Only styles change |
| Change of visibility | retouch | Only display/opacity changes |
| Add/remove elements | repaint | DOM structure changes |
| Method that clears form | repaint | Inputs need to be re-rendered |
| Method that changes theme | retouch | Only CSS variables change |

## Performance Optimization

| Strategy | Description |
|----------|-------------|
| Prefer retouch | Use retouch whenever change is style-only |
| Avoid unnecessary repaint | Don't use repaint when retouch suffices |
| Automatic batching | setImmediate groups multiple updates |
| State guard | isPainted prevents rendering before connected |
| Async | Doesn't block main thread |

## Rendering Lifecycle

| Phase | Callback | Function |
|-------|----------|----------|
| Before | willPaintCallback | Preparation before rendering |
| HTML | htmlCallback | Re-renders HTML template |
| CSS | cssCallback | Re-renders CSS styles |
| After | didPaintCallback | Finalization after rendering |

## Usage in Setters

| Pattern | Description |
|---------|-------------|
| Decorator order | attributeChanged first, then repaint or retouch |
| Setter with repaint | When value affects HTML template |
| Setter with retouch | When value affects only styles |
| Multiple decorators | Allowed to stack decorators |

## Usage in Methods

| Pattern | Description |
|---------|-------------|
| Public methods | Can have repaint or retouch |
| Methods with Symbol | Private methods can have render decorators |
| Event handlers | Can trigger re-rendering |
| Async methods | Compatible with repaint and retouch |

## Component and Style

| Function | Return | Parameter | Description |
|----------|--------|-----------|-------------|
| component | html Template | Component instance | Returns HTML structure of component |
| style | css Template | Component instance | Returns CSS styles of component |

## Reactivity

| Aspect | Description |
|--------|-------------|
| Dynamic values | Component and style access instance properties |
| Conditional | Rendering can use simple conditional logic |
| Interpolation | Interpolated values are recalculated on each render |
| Closure | Functions capture instance context |

## Examples

```typescript
// ❌ Bad — unnecessary complete re-render
render() {
  this.shadowRoot.innerHTML = `<div>${this.data}</div>`
  // clears and rebuilds everything
}

// ✅ Good — surgical DOM update
render() {
  const el = this.shadowRoot.querySelector('.data')
  if (el) el.textContent = this.data
  // updates only what changed
}
```

## Prohibitions

| What to avoid | Reason |
|---------------|--------|
| Use repaint when retouch suffices | Performance waste |
| Re-render in constructor | Component not yet connected |
| Complex logic in component/style | Keep functions simple (rule 010) |
| Side effects in component/style | Functions should be pure |
| Blocking synchronous rendering | Use async decorators |
| Multiple repaints in sequence | Let automatic batching group |

## Best Practices

| Practice | Description |
|----------|-------------|
| Impact analysis | Assess if change affects HTML or only CSS |
| Prefer retouch | Default to retouch, use repaint only if necessary |
| Pure functions | component and style should be pure functions |
| Minimal logic | Keep rendering logic simple |
| Single responsibility | Each render has single purpose |
| Lazy rendering | Component renders only when connected |

## Special Cases

| Case | Treatment |
|------|-----------|
| Headless component | Don't use paint (no visual rendering) |
| Logic only | Behavioral components don't need render |
| Lazy rendering | Component renders only when connected |
| Conditional rendering | Use conditional logic in component |

## Rationale

- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): each render has specific and clear responsibility, paint for initial, repaint for HTML+CSS, retouch only for CSS
- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): choosing adequate decorator (paint/repaint/retouch) makes intention clear and maintains performance
- [069 - Prohibition of Premature Optimization](../../rules/069_proibicao-otimizacao-prematura.md): optimize by choosing retouch vs repaint based on real need, not prematurely
- [007 - Maximum Lines per Class](../../rules/007_limite-maximo-linhas-classe.md): component and style functions should have maximum 15 lines
