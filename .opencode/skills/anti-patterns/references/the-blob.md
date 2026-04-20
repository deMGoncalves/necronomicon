# The Blob (God Object)

**Severidade:** 🔴 Crítico
**Rule associada:** Rule 025

## O que é

Uma única classe ou módulo acumula a maior parte da lógica do sistema, controlando dados e comportamentos que deveriam estar distribuídos entre múltiplas classes com responsabilidades bem definidas.

## Sintomas

- Classe com centenas ou milhares de linhas
- Dezenas de métodos sem coesão entre si
- Quase todo o código do sistema importa essa classe
- Difícil de testar isoladamente — depende de tudo e tudo depende dela
- Mudanças nessa classe quebram funcionalidades não relacionadas

## ❌ Exemplo (violação)

```javascript
// ❌ Uma classe que gerencia usuário, autenticação, e-mail e relatório
class App {
  createUser(data) { ... }
  login(email, password) { ... }
  sendWelcomeEmail(user) { ... }
  generateReport(filters) { ... }
  exportToPDF(report) { ... }
  validateCreditCard(card) { ... }
}
```

## ✅ Refatoração

```javascript
// ✅ Cada classe com uma única responsabilidade
class UserRepository { createUser(data) { ... } }
class AuthService { login(email, password) { ... } }
class EmailService { sendWelcomeEmail(user) { ... } }
class ReportService { generateReport(filters) { ... } }
```

## Codetag sugerida

```typescript
// FIXME: The Blob — classe App tem 8+ responsabilidades distintas
// TODO: Extract UserRepository, AuthService, EmailService, ReportService
```
