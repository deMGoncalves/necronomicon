# Chain of Responsibility

**Categoria:** Comportamental
**Intenção:** Evitar acoplar o remetente de uma requisição ao seu receptor ao dar a mais de um objeto a chance de tratar a requisição, encadeando os receptores.

---

## Quando Usar

- Pipelines de processamento (middleware, filtros HTTP)
- Quando mais de um objeto pode tratar uma requisição e o handler não é conhecido a priori
- Para implementar sistemas de aprovação hierárquica
- Event handling com múltiplos listeners em cascata

## Quando NÃO Usar

- Quando criar cadeias muito longas sem necessidade real (overengineering — rule 064)
- Quando a requisição sempre deve ser processada por um handler específico e conhecido
- Quando a ordem dos handlers importa mas não é explícita — dificulta manutenção

## Estrutura Mínima (TypeScript)

```typescript
abstract class RequestHandler {
  private next: RequestHandler | null = null

  setNext(handler: RequestHandler): RequestHandler {
    this.next = handler
    return handler
  }

  handle(request: number): string | null {
    if (this.next) return this.next.handle(request)
    return null
  }
}

class AuthHandler extends RequestHandler {
  handle(request: number): string | null {
    if (request < 0) return 'Negado: requisição inválida'
    return super.handle(request)
  }
}

class RateLimitHandler extends RequestHandler {
  handle(request: number): string | null {
    if (request > 100) return 'Negado: rate limit excedido'
    return super.handle(request)
  }
}
```

## Exemplo de Uso Real

```typescript
const chain = new AuthHandler()
chain.setNext(new RateLimitHandler())
chain.handle(50)
```

## Relacionada com

- [command.md](command.md): complementa — Command encapsula requisição; Chain of Responsibility define quem a processa
- [observer.md](observer.md): complementa — Observer notifica todos os subscribers; Chain para no primeiro handler que processa
- [rule 002 - Proibição da Cláusula ELSE](../../../rules/002_proibicao-clausula-else.md): reforça — cada handler usa guard clause para decidir se processa ou passa adiante
- [rule 064 - Proibição de Overengineering](../../../rules/064_proibicao-overengineering.md): reforça — não criar cadeias longas sem justificativa

---

**GoF Categoria:** Behavioral
**Fonte:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
