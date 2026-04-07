# Flyweight

**Category:** Structural
**Intent:** Use sharing to support large numbers of fine-grained objects efficiently.

---

## When to Use

- Application needs to create large number of similar objects consuming lots of memory
- Intrinsic state (shareable) can be separated from extrinsic state (unique per context)
- E.g.: characters in text editor, particles in simulations, sprites in games

## When NOT to Use

- Without evidence of memory problem — don't optimize prematurely (rule 069)
- When the separation between intrinsic and extrinsic state is artificial or confusing
- When the number of objects is small and the savings aren't significant

## Minimal Structure (TypeScript)

```typescript
// Intrinsic state: shared among many instances
class CharacterGlyph {
  constructor(
    readonly symbol: string,
    readonly font: string,
    readonly size: number
  ) {}

  render(position: { x: number; y: number }): void {
    // renders symbol at informed position (extrinsic state)
    console.log(`${this.symbol} at ${position.x},${position.y}`)
  }
}

// Factory that manages the Flyweight pool
class GlyphFactory {
  private readonly pool = new Map<string, CharacterGlyph>()

  getGlyph(symbol: string, font: string, size: number): CharacterGlyph {
    const key = `${symbol}-${font}-${size}`
    if (!this.pool.has(key)) {
      this.pool.set(key, new CharacterGlyph(symbol, font, size))
    }
    return this.pool.get(key)!
  }
}
```

## Real Usage Example

```typescript
const factory = new GlyphFactory()
factory.getGlyph('A', 'Arial', 12).render({ x: 0, y: 0 })
```

## Related to

- [singleton.md](singleton.md): complements — Singleton ensures one instance; Flyweight manages pool of shared instances
- [factory-method.md](factory-method.md): depends — GlyphFactory uses factory pattern to manage the Flyweight pool
- [rule 069 - Prohibition of Premature Optimization](../../../rules/069_proibicao-otimizacao-prematura.md): reinforces — use only with evidence of measured memory problem
- [rule 029 - Object Immutability](../../../rules/029_imutabilidade-objetos-freeze.md): reinforces — Flyweights must be immutable since they're shared between contexts

---

**GoF Category:** Structural
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
