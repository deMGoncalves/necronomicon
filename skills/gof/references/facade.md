# Facade

**Category:** Structural
**Intent:** Provide a simplified interface to a set of interfaces in a subsystem, defining a high-level interface that makes the subsystem easier to use.

---

## When to Use

- Simplify complex interface for most common clients
- When having subsystem with many dependencies between classes
- To decouple clients from internal implementations of subsystem
- As a single entry point for modules with many parts

## When NOT to Use

- When Facade accumulates business logic — becomes God Object (rule 025 — The Blob)
- When it becomes Middle Man with no added value, just delegating (rule 061)
- To hide complexity that should be resolved with refactoring

## Minimal Structure (TypeScript)

```typescript
// Complex subsystem with multiple classes
class AudioDecoder { decode(file: string): Buffer { return Buffer.alloc(0) } }
class VideoDecoder { decode(file: string): Buffer { return Buffer.alloc(0) } }
class AudioMixer { mix(audio: Buffer, volume: number): Buffer { return audio } }

// Facade: simple interface to complex subsystem
class VideoPlayerFacade {
  private readonly audioDecoder = new AudioDecoder()
  private readonly videoDecoder = new VideoDecoder()
  private readonly audioMixer = new AudioMixer()

  play(videoFile: string): void {
    const audio = this.audioDecoder.decode(videoFile)
    const video = this.videoDecoder.decode(videoFile)
    const mixed = this.audioMixer.mix(audio, 1.0)
    // renders video with mixed audio
  }
}
```

## Real Usage Example

```typescript
new VideoPlayerFacade().play('video.mp4')
```

## Related to

- [adapter.md](adapter.md): complements — Adapter converts incompatible interface; Facade simplifies existing interface
- [mediator.md](mediator.md): complements — both simplify dependencies; Mediator coordinates objects that know each other; Facade defines simple interface to subsystem
- [rule 025 - Prohibition of Anti-Pattern The Blob](../../../rules/025_proibicao-anti-pattern-the-blob.md): reinforces — Facade should not contain business logic, only delegate
- [rule 061 - Prohibition of Middle Man](../../../rules/061_proibicao-middle-man.md): reinforces — Facade should simplify, not be empty wrapper
- [rule 014 - Dependency Inversion Principle](../../../rules/014_principio-inversao-dependencia.md): complements — clients depend on Facade, isolated from concrete subsystem classes

---

**GoF Category:** Structural
**Source:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
