# Proxy

**Category:** Structural
**Intent:** Provide a substitute or placeholder for another object to control access to it.

---

## When to Use

- Lazy loading: load heavy resource only when necessary
- Cache: store result of expensive operations
- Access control: verify permissions before delegating
- Transparent logging and monitoring

## When NOT to Use

- When it doesn't add real behavior — becomes useless Middle Man (rule 061)
- For simple delegation without control, cache or access — use the object directly
- When Proxy latency exceeds the benefit it provides

## Minimal Structure (TypeScript)

```typescript
interface ImageLoader {
  display(): string
}

class RealImage implements ImageLoader {
  constructor(private readonly filename: string) {
    this.loadFromDisk() // expensive operation
  }

  private loadFromDisk(): void {
    console.log(`Loading ${this.filename} from disk...`)
  }

  display(): string { return `Displaying ${this.filename}` }
}

// Proxy with lazy loading and cache
class ImageProxy implements ImageLoader {
  private realImage: RealImage | null = null

  constructor(private readonly filename: string) {}

  display(): string {
    if (!this.realImage) {
      this.realImage = new RealImage(this.filename) // loads only when necessary
    }
    return this.realImage.display()
  }
}
```

## Real Usage Example

```typescript
const image: ImageLoader = new ImageProxy('photo.jpg')
image.display()
```

## Related to

- [adapter.md](adapter.md): complements — Adapter converts interface; Proxy maintains same interface and controls access
- [decorator.md](decorator.md): complements — similar structure; Decorator adds behavior; Proxy controls access to real object
- [rule 061 - Prohibition of Middle Man](../../../rules/061_proibicao-middle-man.md): reinforces — Proxy should add real control (cache, access, lazy load), not just delegate
- [rule 036 - Restriction of Functions with Side Effects](../../../rules/036_restricao-funcoes-efeitos-colaterais.md): complements — Proxy side effects (cache, log) should be documented and intentional

---

**GoF Category:** Structural
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
