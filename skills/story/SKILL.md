---
name: story
description: Convention for Storybook story structure — when creating or updating Storybook stories — when structuring component stories with variants, states and documentation
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Story

Convention for Storybook story structure.

---

## When to Use

Use when creating or updating component stories.

## Structure

| Element | Purpose |
|---------|---------|
| Import | Import component at top |
| Export default | Storybook configuration |
| Export Default | Default story with basic args |

## Configuration

| Property | Description |
|----------|-------------|
| title | Path in navigation menu |
| tags | Tags for documentation generation |
| parameters | Presentation settings |
| argTypes | Control definitions and documentation |
| render | Component rendering function |

## ArgTypes

| Field | Purpose |
|-------|---------|
| control | UI control type |
| options | Available options for selection |
| description | Attribute documentation |
| table | Metadata and default values |

## Control Types

| Type | Usage |
|------|-------|
| select | Selection between predefined options |
| text | Free text input |
| boolean | True/false toggle |
| number | Numeric input |
| color | Color picker |

## Rules

| Rule | Description |
|------|-------------|
| File format | Use JavaScript, not TypeScript |
| Exports | Single Default story per file |
| Tests | No play functions or interaction tests |
| Controls | Disable global controls |
| Imports | Always import component at start |
| Rendering | Create element via DOM API |

## Principles

| Principle | Application |
|-----------|-------------|
| Simplicity | Story should show basic component usage |
| Isolation | Each story is independent |
| Documentation | ArgTypes document behavior |

## Examples

```typescript
// ❌ Bad — story without metadata or variants
export default { component: Button }
export const Default = {}

// ✅ Good — structured story with metadata and variants
import type { Meta, StoryObj } from '@storybook/web-components'

const meta: Meta = {
  title: 'Components/Button',
  component: 'app-button',
  tags: ['autodocs'],
}
export default meta

export const Primary: StoryObj = {
  args: { label: 'Click me', variant: 'primary' }
}
export const Disabled: StoryObj = {
  args: { label: 'Disabled', disabled: true }
}
```

## Prohibitions

| What to avoid | Reason |
|---------------|--------|
| Multiple stories in same file | Single Default story per file (rule 010) |
| Play functions or tests | Stories are for visualization, not tests |
| Complex logic in render | Keep render simple and direct (rule 022) |
| Undocumented controls | All argTypes should have description |
| Stories without real example | Show real component use cases |

## Rationale

- [022 - Prioritization of Simplicity and Clarity](../../rules/022_priorizacao-simplicidade-clareza.md): simple stories focus on essentials, reducing cognitive complexity
- [010 - Single Responsibility Principle](../../rules/010_principio-responsabilidade-unica.md): each story has single responsibility to demonstrate one component use case
- [026 - Comment Quality](../../rules/026_qualidade-comentarios-porque.md): documentation via argTypes is allowed as it explains "what" the argument does, not code
