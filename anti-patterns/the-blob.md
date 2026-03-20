---
titulo: The Blob (God Object)
aliases:
  - God Object
  - God Class
  - The Blob
tipo: anti-pattern
id: AP-01
severidade: 🔴 Crítico
origem: antipatterns-book
tags: [anti-pattern, estrutural, responsabilidade, acoplamento]
criado: 2026-03-20
relacionados:
  - "[[proibicao-anti-padrao-blob]]"
  - "[[001_single-responsibility-principle]]"
  - "[[shotgun-surgery]]"
---

# The Blob (God Object)

*God Object / God Class / The Blob*

---

## Definição

Uma única classe ou módulo acumula a maior parte da lógica do sistema, controlando dados e comportamentos que deveriam estar distribuídos entre múltiplas classes com responsabilidades bem definidas.

## Sintomas

- Classe com centenas ou milhares de linhas
- Dezenas de métodos sem coesão entre si
- Quase todo o código do sistema importa essa classe
- Difícil de testar isoladamente — depende de tudo e tudo depende dela
- Mudanças nessa classe quebram funcionalidades não relacionadas

## Causas Raiz

- Crescimento incremental sem refatoração — "só adiciono aqui porque já está funcionando"
- Falta de design inicial: uma única classe criada para "começar" e nunca decompostas
- Pressão de prazo que inibe refatoração preventiva

## Consequências

- Acoplamento máximo: toda mudança tem efeitos colaterais imprevisíveis
- Testabilidade zero: impossível testar unidades em isolamento
- Onboarding lento: novos desenvolvedores precisam entender a classe inteira para mudar qualquer coisa
- Merge conflicts constantes: toda equipe edita o mesmo arquivo

## Solução / Refatoração

Aplicar **Extract Class** (Fowler): identificar grupos de atributos e métodos coesos e movê-los para classes dedicadas. Usar o SRP como guia — cada classe deve ter apenas um motivo para mudar.

## Exemplo — Problemático

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

## Exemplo — Refatorado

```javascript
// ✅ Cada classe com uma única responsabilidade
class UserRepository { createUser(data) { ... } }
class AuthService { login(email, password) { ... } }
class EmailService { sendWelcomeEmail(user) { ... } }
class ReportService { generateReport(filters) { ... } }
```

## Rules que Previnem

- [[proibicao-anti-padrao-blob]] — proíbe explicitamente este padrão
- [[001_single-responsibility-principle]] — define o critério de decomposição

## Relacionados

- [[shotgun-surgery]] — consequência direta: mudança no Blob exige alterações em todo o sistema
- [[divergent-change]] — Blob sofre divergent change constantemente
- [[lava-flow]] — Blobs acumulam lava flow ao longo do tempo
