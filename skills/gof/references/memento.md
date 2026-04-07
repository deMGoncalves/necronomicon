# Memento

**Category:** Behavioral
**Intent:** Without violating encapsulation, capture and externalize an object's internal state so it can be restored to that state later.

---

## When to Use

- Implement undo/redo with encapsulation preservation
- State snapshots for rollback
- Save and restore game state
- Checkpoints in long processes

## When NOT to Use

- When saving mementos too frequently consumes excessive memory without control (rule 069)
- When internal state is already immutable — no need for snapshot
- When the object has external references that cannot be captured in snapshot

## Minimal Structure (TypeScript)

```typescript
class EditorMemento {
  constructor(private readonly content: string) {}
  restore(): string { return this.content }
}

class Editor {
  private content = ''

  type(text: string): void { this.content += text }

  save(): EditorMemento {
    return new EditorMemento(this.content)
  }

  restore(memento: EditorMemento): void {
    this.content = memento.restore()
  }

  getContent(): string { return this.content }
}

class History {
  private readonly mementos: EditorMemento[] = []
  push(memento: EditorMemento): void { this.mementos.push(memento) }
  pop(): EditorMemento | undefined { return this.mementos.pop() }
}
```

## Real Usage Example

```typescript
const history = new History()
history.push(editor.save())
editor.type('X')
editor.restore(history.pop()!)
```

## Related to

- [command.md](command.md): complements — Command records operations for undo; Memento saves state snapshots for rollback
- [state.md](state.md): complements — State defines transitions; Memento can save and restore object states
- [rule 029 - Object Immutability](../../../rules/029_imutabilidade-objetos-freeze.md): reinforces — EditorMemento should be immutable after creation to ensure snapshot integrity
- [rule 069 - Prohibition of Premature Optimization](../../../rules/069_proibicao-otimizacao-prematura.md): reinforces — saving mementos excessively can consume memory without real need

---

**GoF Category:** Behavioral
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
