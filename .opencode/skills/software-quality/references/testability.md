# Testability — Testabilidade

**Dimensão:** Revisão
**Severidade Default:** 🔴 Crítica
**Pergunta Chave:** É fácil testar?

## O que é

O esforço necessário para testar o software e garantir que ele funciona corretamente. Alta testabilidade significa que componentes podem ser testados isoladamente, com entradas e saídas claras, sem depender de infraestrutura externa.

## Indicadores de Problema

| Situação | Severidade |
|----------|-----------|
| Código de negócio impossível de testar | 🔴 Blocker |
| Singleton usado em lógica crítica | 🔴 Blocker |
| Dependência concreta em Service | 🟠 Important |
| Date.now() sem injeção | 🟡 Suggestion |

## Exemplo de Violação

```javascript
// ❌ Não testável - cria dependência internamente
class UserService {
  async getUser(id) {
    const db = new DatabaseConnection(); // Impossível mockar
    return db.query(`SELECT * FROM users WHERE id = ${id}`);
  }
}

// ✅ Testável - dependência injetada
class UserService {
  constructor(userRepository) {
    this.userRepository = userRepository;
  }

  async getUser(id) {
    return this.userRepository.findById(id);
  }
}

// No teste:
const mockRepo = { findById: vi.fn().mockResolvedValue(mockUser) };
const service = new UserService(mockRepo);
```

## Codetags Sugeridos

```javascript
// TEST(014): Impossível testar - dependência concreta interna
// TEST: Necessário mockar time para testar
```

## Calibração de Severidade

| Situação | Severidade |
|----------|-----------|
| Código de negócio impossível de testar | 🔴 Blocker |
| Singleton usado em lógica crítica | 🔴 Blocker |
| Dependência concreta em Service | 🟠 Important |
| Date.now() sem injeção | 🟡 Suggestion |

## Rules Relacionadas

- 014 - Princípio de Inversão de Dependência
- 032 - Cobertura Mínima de Teste
- 036 - Restrição de Funções com Efeitos Colaterais
