# Overengineering (Complexidade Desnecessária)

**Severidade:** 🟡 Médio
**Rule associada:** Rule 064

## O que é

Projetar ou implementar uma solução muito mais complexa do que o problema exige. Adicionar abstrações, camadas, padrões de design, sistemas de plugin ou configurabilidade antes de haver evidência de necessidade real.

## Sintomas

- Introduzir pattern without clear problem being solved (ex: Strategy pattern sem variation de algorithms)
- Interfaces com um único implementador "para facilitar testes futuros"
- Sistemas de configuração para algo que nunca vai mudar
- Abstrações de 5 camadas para uma operação CRUD
- Design Patterns aplicados onde código direto funcionaria
- "Eu fiz genérico para poder reusar depois"

## ❌ Exemplo (violação)

```javascript
// ❌ Sistema de plugin para salvar um usuário no banco
class UserRepository {
  constructor(storageStrategy) { this.strategy = storageStrategy; }
  save(user) { return this.strategy.persist(user); }
}

class DatabaseStorageStrategy {
  constructor(adapterFactory) { this.adapter = adapterFactory.create(); }
  persist(user) { return this.adapter.execute('INSERT', user); }
}

// Nunca houve outro storage. Nunca haverá.
```

## ✅ Refatoração

```javascript
// ✅ Direto ao ponto — refatora quando a necessidade for real (YAGNI + KISS)
async function saveUser(user) {
  return db.users.create(user);
}

// Só adicione abstração quando houver múltiplos storages REAIS
```

## Codetag sugerida

```typescript
// FIXME: Overengineering — 4 layers de abstração para um simples db.create()
// TODO: Simplificar: usar db.users.create() diretamente até existir 2º storage
```
