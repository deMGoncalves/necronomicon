# Facade

**Categoria:** Estrutural
**Intenção:** Fornecer interface simplificada para um conjunto de interfaces em um subsistema, definindo interface de alto nível que facilita o uso do subsistema.

---

## Quando Usar

- Simplificar interface complexa para os clientes mais comuns
- Ao ter subsistema com muitas dependências entre classes
- Para desacoplar clientes de implementações internas do subsistema
- Como ponto único de entrada para módulos com muitas partes

## Quando NÃO Usar

- Quando o Facade acumula lógica de negócio — passa a ser God Object (rule 025 — The Blob)
- Quando vira Middle Man sem valor agregado, apenas delegando (rule 061)
- Para esconder complexidade que deveria ser resolvida com refatoração

## Estrutura Mínima (TypeScript)

```typescript
// Subsistema complexo com múltiplas classes
class AudioDecoder { decode(file: string): Buffer { return Buffer.alloc(0) } }
class VideoDecoder { decode(file: string): Buffer { return Buffer.alloc(0) } }
class AudioMixer { mix(audio: Buffer, volume: number): Buffer { return audio } }

// Facade: interface simples para o subsistema complexo
class VideoPlayerFacade {
  private readonly audioDecoder = new AudioDecoder()
  private readonly videoDecoder = new VideoDecoder()
  private readonly audioMixer = new AudioMixer()

  play(videoFile: string): void {
    const audio = this.audioDecoder.decode(videoFile)
    const video = this.videoDecoder.decode(videoFile)
    const mixed = this.audioMixer.mix(audio, 1.0)
    // renderiza vídeo com áudio misturado
  }
}
```

## Exemplo de Uso Real

```typescript
new VideoPlayerFacade().play('video.mp4')
```

## Relacionada com

- [adapter.md](adapter.md): complementa — Adapter converte interface incompatível; Facade simplifica interface existente
- [mediator.md](mediator.md): complementa — ambos simplificam dependências; Mediator coordena objetos que se conhecem; Facade define interface simples para subsistema
- [rule 025 - Proibição do Anti-Pattern The Blob](../../../rules/025_proibicao-anti-pattern-the-blob.md): reforça — Facade não deve conter lógica de negócio, apenas delegar
- [rule 061 - Proibição de Middle Man](../../../rules/061_proibicao-middle-man.md): reforça — Facade deve simplificar, não ser wrapper vazio
- [rule 014 - Princípio de Inversão de Dependência](../../../rules/014_principio-inversao-dependencia.md): complementa — clientes dependem da Facade, isolados das classes concretas do subsistema

---

**GoF Categoria:** Structural
**Fonte:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
