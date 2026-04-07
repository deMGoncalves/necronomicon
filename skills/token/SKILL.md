---
name: token
description: Convention for using Design Tokens in CSS styles — when creating or modifying CSS styles, reviewing code that uses hardcoded values for color, spacing or typography instead of Design System tokens
model: sonnet
allowed-tools: Read, Write, Edit, Grep, Glob
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Token

Convention for using CSS Design Tokens when styling components, replacing hardcoded values with Design System tokens from `packages/pixel/tokens/`.

---

## When to Use

| Situation | Action |
|-----------|--------|
| Creating styles for new component | Consult mapping below for each property |
| Modifying existing styles with hardcoded values | Replace with corresponding token |
| Choosing color, size or spacing | Select token by semantic context |

## Principle

| Aspect | Details |
|--------|---------|
| Consistency | Tokens ensure all components share same visual scale |
| Maintainability | Centralized token changes update entire system |
| Dark mode | Colors use `light-dark()` internally — using token already guarantees automatic support |

## Mapping: Property → Token Category

| CSS Property | Token Category | Correct Example |
|--------------|----------------|-----------------|
| `color` | `--color-*` | `color: var(--color-master-dark)` |
| `background`, `background-color` | `--color-*` | `background: var(--color-master-lightest)` |
| `border-color` | `--color-*` | `border-color: var(--color-master-light)` |
| `border-width` | `--border-width-*` | `border-width: var(--border-width-thin)` |
| `border-radius` | `--border-radius-*` | `border-radius: var(--border-radius-sm)` |
| `padding`, `padding-*` | `--spacing_inset-*` | `padding: var(--spacing_inset-xs)` |
| `margin`, `margin-*` | `--spacing-*` | `margin-bottom: var(--spacing-nano)` |
| `gap`, `row-gap`, `column-gap` | `--spacing-*` | `gap: var(--spacing-nano)` |
| `font-size` | `--font-size-*` | `font-size: var(--font-size-xs)` |
| `font-family` | `--font-family-*` | `font-family: var(--font-family-base)` |
| `font-weight` | `--font-weight-*` | `font-weight: var(--font-weight-regular)` |
| `line-height` | `--line-height-*` | `line-height: var(--line-height-md)` |
| `opacity` | `--opacity-level-*` | `opacity: var(--opacity-level-medium)` |
| `box-shadow` | `--shadow-level-*` | `box-shadow: var(--shadow-level-1)` |
| `fill`, `stroke` (SVG) | `--color-*` | `fill: var(--color-primary)` |

## Scale Rules

### Colors — Tone Scale

Each color palette has 5 intensity levels. Intensity defines **where** to use:

| Tone | Usage | Example |
|------|-------|---------|
| `*-darker` | Headers and strongly highlighted text | `color: var(--color-primary-darker)` |
| `*-dark` | Main and interactive text | `color: var(--color-primary-dark)` |
| `*` (base) | Buttons and interactive elements | `background: var(--color-primary)` |
| `*-light` | Icons and subtle highlights | `color: var(--color-primary-light)` |
| `*-lighter` | Component backgrounds | `background: var(--color-primary-lighter)` |

**Critical rule:** never use dark tone in `background` nor light tone in text `color`.

### Available Palettes

| Palette | Semantic Usage |
|---------|---------------|
| `master` | Gray scale — neutral text, borders and backgrounds |
| `primary` | Brand identity — main actions |
| `complete` | Progress and completion |
| `success` | Positive feedback |
| `warning` | Warnings |
| `danger` | Errors |
| `info` | Neutral informative |
| `menu` | Navigation in dark contexts |
| `pure-white` / `pure-black` | Absolute contrast only |

### Spacing — External vs Internal

| Context | Token | Prohibition |
|---------|-------|-------------|
| `padding` | `--spacing_inset-*` | Never use `--spacing-*` in padding |
| `margin` | `--spacing-*` | Never use `--spacing_inset-*` in margin |
| `gap` | `--spacing-*` | Never use `--spacing_inset-*` in gap |

## Semantic Context

Component type determines which tokens are required:

| Component | Property | Required Token |
|-----------|----------|----------------|
| Interactive button | `background` | `--color-primary` |
| Interactive button | `border-radius` | `--border-radius-sm` |
| Input | `border-width` | `--border-width-thin` |
| Input | `border-radius` | `--border-radius-xs` |
| Error text | `color` | `--color-danger-*` |
| Success text | `color` | `--color-success-*` |
| Neutral border | `border-color` | `--color-master-light` |
| Main background | `background` | `--color-master-lightest` |
| Title / header | `font-family` | `--font-family-highlight` |
| Title / header | `font-weight` | `--font-weight-bold` |
| Regular text | `font-family` | `--font-family-base` |
| Paragraph | `line-height` | `--line-height-md` |

## Exceptions

Properties below **have no token** and can use direct values:

| Property | Allowed Values |
|----------|---------------|
| `display`, `position`, `visibility`, `overflow` | Any valid value |
| `flex`, `flex-grow`, `flex-shrink`, `order` | Numeric values |
| `z-index` | Numeric values |
| `width`, `height` | `100%`, `auto`, `min-content`, `max-content` |
| `min-width`, `max-width` | `0`, `none`, `100%` |
| `top`, `left`, `right`, `bottom` | `0` |
| `border-style` | `solid`, `dashed`, `dotted` |
| `transition`, `animation` | Duration and timing |
| `transform` | Any transformation function |
| `cursor` | `pointer`, `default`, `not-allowed` |
| `pointer-events`, `user-select` | Any valid value |

## Examples

```css
/* ❌ Bad — hardcoded values */
.button {
  background: #3B82F6;
  padding: 8px 16px;
  font-size: 14px;
}

/* ✅ Good — Design Tokens */
.button {
  background: var(--color-action-default);
  padding: var(--spacing-sm) var(--spacing-md);
  font-size: var(--font-size-body);
}
```

## Prohibitions

| What to avoid | Reason |
|---------------|--------|
| `color: #000` or `color: black` | Use `--color-master-darkest` or semantic palette (rule 024) |
| `background: #fff` or `background: white` | Use `--color-master-lightest` or `--color-pure-white` (rule 024) |
| `border: 1px solid #ccc` (shorthand with fixed values) | Separate into `border-width`, `border-style` and `border-color` using tokens |
| `padding: 16px` | Use `--spacing_inset-xs` — padding is internal spacing (rule 024) |
| `margin: 8px` | Use `--spacing-nano` — margin is external spacing (rule 024) |
| `gap: 24px` | Use `--spacing-xxs` — gap is external spacing (rule 024) |
| `font-size: 16px` | Use `--font-size-xs` — typography should use tokens (rule 024) |
| `font-weight: 700` | Use `--font-weight-bold` — typographic weight should use tokens (rule 024) |
| `opacity: 0.5` | Use closest `--opacity-level-*` |
| `--spacing-*` in `padding` | Padding is internal, use `--spacing_inset-*` |
| `--spacing_inset-*` in `margin` or `gap` | Margin and gap are external, use `--spacing-*` |
| Dark color token in `background` | Use `*-lighter` or `*-lightest` variation |
| Light color token in text `color` | Use `*-darker` or `*-dark` variation |

## Rationale

- [024 - Prohibition of Magic Constants](../../rules/024_proibicao-constantes-magicas.md): literal values in CSS are magic constants, should be replaced by named tokens for traceability and maintenance
- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): tokens reduce cognitive complexity by giving explicit semantics to style values
- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): tokens centralize visual definition responsibility, avoiding individual components making design decisions
- [016 - Common Closure Principle](../../rules/016_principio-fechamento-comum.md): theme or visual scale changes are localized in tokens, without altering components
