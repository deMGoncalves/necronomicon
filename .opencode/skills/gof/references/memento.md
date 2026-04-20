# Memento

**Categoria:** Comportamental
**Intenção:** Sem violar encapsulamento, capturar e externalizar estado interno de um objeto para que possa ser restaurado a esse estado posteriormente.

---

## Quando Usar

- Implementar undo/redo com preservação de encapsulamento
- Snapshots de estado para rollback
- Salvar e restaurar estado de jogos
- Checkpoints em processos longos

## Quando NÃO Usar

- Quando salvar mementos muito frequentemente consome memória excessiva sem controle (rule 069)
- Quando o estado interno já é imutável — não há necessidade de snapshot
- Quando o objeto tem referências externas que não podem ser capturadas no snapshot

## Estrutura Mínima (TypeScript)

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

## Exemplo de Uso Real

```typescript
const history = new History()
history.push(editor.save())
editor.type('X')
editor.restore(history.pop()!)
```

## Relacionada com

- [command.md](command.md): complementa — Command registra operações para undo; Memento salva snapshots de estado para rollback
- [state.md](state.md): complementa — State define transições; Memento pode salvar e restaurar estados do objeto
- [rule 029 - Imutabilidade de Objetos](../../../rules/029_imutabilidade-objetos-freeze.md): reforça — EditorMemento deve ser imutável após criação para garantir integridade do snapshot
- [rule 069 - Proibição de Otimização Prematura](../../../rules/069_proibicao-otimizacao-prematura.md): reforça — salvar mementos excessivamente pode consumir memória sem necessidade real

---

**GoF Categoria:** Behavioral
**Fonte:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
