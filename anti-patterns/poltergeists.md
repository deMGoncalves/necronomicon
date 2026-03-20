---
titulo: Poltergeists (Classes Fantasma)
aliases:
  - Poltergeists
  - Classes Fantasma
  - Gopher Classes
tipo: anti-pattern
id: AP-07
severidade: 🟡 Médio
origem: antipatterns-book
tags: [anti-pattern, estrutural, responsabilidade, complexidade]
criado: 2026-03-20
relacionados:
  - "[[the-blob]]"
  - "[[middle-man]]"
  - "[[001_single-responsibility-principle]]"
---

# Poltergeists (Classes Fantasma)

*Poltergeists / Gopher Classes*

---

## Definição

Classes com papel efêmero e transitório: existem apenas para passar dados entre outras classes ou inicializar algo, sem estado real nem comportamento significativo. Somem logo após cumprir seu papel mínimo, como um poltergeist.

## Sintomas

- Classes com um único método público, geralmente chamado de `execute()`, `run()` ou `process()`
- Classes sem atributos (sem estado) que apenas chamam métodos de outras classes
- Controllers que apenas delegam para um service que apenas delega para um repository
- "Orchestrators" que não orquestram nada — apenas repassam chamadas

## Causas Raiz

- Aplicação mecânica de padrões de camadas sem entender o propósito
- Camadas adicionadas por padrão sem necessidade real
- Confusão entre separação de responsabilidades e criação de intermediários sem valor

## Consequências

- Complexidade acidental: mais arquivos, mais imports, mais nomes para entender
- Dificuldade de rastreamento: para entender o fluxo é preciso saltar entre N arquivos
- Testes desnecessários: testar classes que não fazem nada

## Solução / Refatoração

Aplicar **Inline Class** (Fowler): se uma classe não faz nada além de delegar, absorva seu comportamento na classe que a usa. Adicionar uma camada apenas quando ela tem responsabilidade real.

## Exemplo — Problemático

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

## Exemplo — Refatorado

```javascript
// ✅ Chamar UserService diretamente
userService.create(data);
```

## Rules que Previnem

- [[priorizacao-simplicidade-clareza]] — KISS: não adicione camadas sem necessidade
- [[001_single-responsibility-principle]] — SRP não exige que cada operação seja uma classe

## Relacionados

- [[middle-man]] — versão em code smell: classe que só delega
- [[the-blob]] — oposto extremo: Blob faz tudo, Poltergeist não faz nada
