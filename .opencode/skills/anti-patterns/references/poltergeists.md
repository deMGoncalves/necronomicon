# Poltergeists (Classes Fantasma)

**Severidade:** 🟡 Médio
**Rule associada:** Rule 065

## O que é

Classes com papel efêmero e transitório: existem apenas para passar dados entre outras classes ou inicializar algo, sem estado real nem comportamento significativo. Somem logo após cumprir seu papel mínimo, como um poltergeist. Middle Men de vida curta.

## Sintomas

- Classes/services criados apenas para adaptar parâmetros ou formatar chamadas e descartados
- Classes com um único método público, geralmente chamado de `execute()`, `run()` ou `process()`
- Classes sem atributos (sem estado) que apenas chamam métodos de outras classes
- Controllers que apenas delegam para um service que apenas delega para um repository
- "Orchestrators" que não orquestram nada — apenas repassam chamadas
- Constructed objects never stored, never tested, never referenced beyond immediate call

## ❌ Exemplo (violação)

```javascript
// ❌ Classe que existe apenas para chamar outra
class UserInitializer {
  constructor(userService) {
    this.userService = userService;
  }
  initialize(data) {
    return this.userService.create(data); // só isso
  }
}

// Chamador precisa instanciar UserInitializer só para chegar em UserService
const initializer = new UserInitializer(userService);
initializer.initialize(data);
```

## ✅ Refatoração

```javascript
// ✅ Chamar UserService diretamente (Inline Class)
userService.create(data);

// Se a classe adicionar transformação ou validação real, aí faz sentido existir
```

## Codetag sugerida

```typescript
// FIXME: Poltergeist — UserInitializer apenas delega para userService.create()
// TODO: Inline Class — chamar userService.create() diretamente
```
