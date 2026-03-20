---
titulo: Proibição do Anti-Pattern The Blob (God Object)
aliases:
  - God Object
  - The Blob
tipo: rule
id: CC-05
severidade: 🔴 Crítico
origem: clean-code
tags:
  - clean-code
  - estrutural
  - solid
  - srp
resolver: Antes do commit
relacionados:
  - "[[001_single-responsibility-principle]]"
  - "[[007_maximum-lines-per-class]]"
  - "[[regra-escoteiro-refatoracao-continua]]"
criado: 2025-10-08
---

# Proibição do Anti-Pattern The Blob (God Object)

*God Object / The Blob*


---

## Definição

Proíbe a criação de classes que concentram a maior parte da lógica e dos dados do sistema, resultando em um **God Object** (The Blob) que outras classes pequenas apenas orbitam e acessam.

## Motivação

Viola severamente o Princípio da Responsabilidade Única (SRP), resultando na **pior forma de acoplamento e baixa coesão**. Torna a classe impossível de testar e o sistema extremamente frágil a mudanças.

## Quando Aplicar

- [ ] Uma classe não deve conter mais de **10** métodos públicos (excluindo *getters* e *setters* permitidos).
- [ ] O número de dependências (imports) de classes concretas em uma única classe não deve exceder **5**.
- [ ] Se a classe viola os limites de `STRUCTURAL-007` (50 linhas) e `BEHAVIORAL-010` (7 métodos), deve ser classificada como *Blob* e refatorada.

## Quando NÃO Aplicar

- **Encapsulamento de Legado**: Classes grandes podem ser aceitas quando encapsulam um sistema legado não-OO para acessá-lo a partir do sistema OO.

## Violação — Exemplo

```javascript
// ❌ Uma classe que sabe de tudo e faz tudo
class AppManager {
  constructor() {
    this.db = new Database();
    this.cache = new Cache();
    this.mailer = new Mailer();
    this.logger = new Logger();
    this.auth = new Auth();
    this.payment = new PaymentGateway(); // 6+ dependências
  }

  createUser() { /* ... */ }
  deleteUser() { /* ... */ }
  processPayment() { /* ... */ }
  sendEmail() { /* ... */ }
  generateReport() { /* ... */ }
  // ... 15 outros métodos
}
```

## Conformidade — Exemplo

```javascript
// ✅ Responsabilidades separadas em classes coesas
class UserService {
  constructor(userRepository, mailer) { /* max 2-3 deps */ }
  createUser() { /* ... */ }
  deleteUser() { /* ... */ }
}

class PaymentService {
  constructor(paymentGateway, logger) { /* ... */ }
  processPayment() { /* ... */ }
}
```

## Anti-Patterns Relacionados

- [[the-blob|God Object / The Blob]] — classe que conhece e controla todo o sistema
- [[feature-envy|Feature Envy]] — métodos que usam dados de outras classes mais do que os próprios

## Como Detectar

### Manual

Identificar classes que são constantemente modificadas por diversas *feature requests* diferentes.

### Automático

SonarQube: LCOM (Lack of Cohesion in Methods) e WMC (Weighted Methods Per Class) muito elevados.

## Relação com ICP

Blobs acumulam todos os componentes do ICP: **CC_base** elevado (muitos caminhos), **Aninhamento** profundo, **Responsabilidades** múltiplas e **Acoplamento** máximo. A decomposição de um Blob é a ação de maior redução de ICP possível.

## Relacionados

- [[001_single-responsibility-principle|Princípio da Responsabilidade Única]] — viola
- [[007_maximum-lines-per-class|Limite Máximo de Linhas por Classe]] — reforça
- [[regra-escoteiro-refatoracao-continua]] — complementa
