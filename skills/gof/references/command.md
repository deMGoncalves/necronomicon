# Command

**Category:** Behavioral
**Intent:** Encapsulate a request as an object, allowing to parameterize clients with different requests, queue, log and support reversible operations.

---

## When to Use

- Implement undo/redo
- Queue operations for deferred execution
- Log operation history
- Implement transactions that can be reverted

## When NOT to Use

- For simple operations without need for undo/queuing (overengineering — rule 064)
- When the overhead of creating Command objects exceeds the benefit
- When the operation doesn't need to be stored, undone or passed along

## Minimal Structure (TypeScript)

```typescript
interface Command {
  execute(): void
  undo(): void
}

class TextEditor {
  private text = ''
  insertText(text: string): void { this.text += text }
  deleteText(length: number): void { this.text = this.text.slice(0, -length) }
  getText(): string { return this.text }
}

class InsertCommand implements Command {
  constructor(
    private readonly editor: TextEditor,
    private readonly text: string
  ) {}

  execute(): void { this.editor.insertText(this.text) }
  undo(): void { this.editor.deleteText(this.text.length) }
}

class CommandHistory {
  private readonly history: Command[] = []

  execute(command: Command): void {
    command.execute()
    this.history.push(command)
  }

  undo(): void {
    this.history.pop()?.undo()
  }
}
```

## Real Usage Example

```typescript
const history = new CommandHistory()
history.execute(new InsertCommand(editor, 'Hello'))
```

## Related to

- [memento.md](memento.md): complements — Command records operations for undo; Memento saves state for rollback
- [chain-of-responsibility.md](chain-of-responsibility.md): complements — Chain defines who processes; Command encapsulates what is processed
- [rule 010 - Single Responsibility Principle](../../../rules/010_principio-responsabilidade-unica.md): reinforces — each Command encapsulates a single reversible operation
- [rule 036 - Restriction of Functions with Side Effects](../../../rules/036_restricao-funcoes-efeitos-colaterais.md): reinforces — execute() is explicit Command with intentional and documented side effect
- [rule 064 - Prohibition of Overengineering](../../../rules/064_proibicao-overengineering.md): reinforces — don't use without real need for undo or history

---

**GoF Category:** Behavioral
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
