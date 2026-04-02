---
name: solid
description: "5 princípios SOLID para design orientado a objetos. Use quando @architect decidir design de classes/interfaces, ou @reviewer verificar conformidade com rules 010-014."
model: haiku
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# SOLID Principles

## O que é

SOLID é um acrônimo para 5 princípios fundamentais de design orientado a objetos criados por Robert C. Martin (Uncle Bob). Estes princípios formam a base para código limpo, manutenível e escalável em sistemas OOP.

## Quando Usar

- **@architect projetando sistema**: Aplique ao decidir design de classes, interfaces e dependências
- **@developer implementando features**: Valide que código segue os 5 princípios durante escrita
- **@reviewer verificando código**: Use como checklist para identificar violações arquiteturais
- **Refatoração**: Diagnostique qual princípio foi violado para guiar refatoração

## Princípios SOLID

| Letra | Princípio | Rule ID | Pergunta Chave | Arquivo |
|-------|-----------|---------|----------------|---------|
| **S** | Single Responsibility | 010 | Esta classe tem uma única razão para mudar? | [srp.md](references/srp.md) |
| **O** | Open/Closed | 011 | Posso adicionar comportamento sem modificar código existente? | [ocp.md](references/ocp.md) |
| **L** | Liskov Substitution | 012 | Posso substituir a classe base pela derivada sem quebrar? | [lsp.md](references/lsp.md) |
| **I** | Interface Segregation | 013 | Clientes dependem apenas das interfaces que usam? | [isp.md](references/isp.md) |
| **D** | Dependency Inversion | 014 | Módulos de alto nível dependem de abstrações, não concretas? | [dip.md](references/dip.md) |

## Guia Rápido: Qual Princípio Foi Violado?

```
Classe muda por múltiplas razões?                      → S: Single Responsibility
Adicionar feature exige modificar classe existente?    → O: Open/Closed
Substituir pai por filho quebra comportamento?         → L: Liskov Substitution
Interface força cliente a implementar métodos vazios?  → I: Interface Segregation
Service instancia classes concretas com new?           → D: Dependency Inversion
```

## Decision Tree: Violando Qual Princípio?

```mermaid
graph TD
    A[Code Smell Detectado] --> B{Classe muda<br/>por N razões?}
    B -->|Sim| SRP[Viola SRP]
    B -->|Não| C{Adicionar feature<br/>modifica classe?}
    C -->|Sim| OCP[Viola OCP]
    C -->|Não| D{Substituir pai<br/>por filho quebra?}
    D -->|Sim| LSP[Viola LSP]
    D -->|Não| E{Interface tem<br/>métodos não usados?}
    E -->|Sim| ISP[Viola ISP]
    E -->|Não| F{Depende de<br/>classes concretas?}
    F -->|Sim| DIP[Viola DIP]
```

## Proibições

Estas combinações violam **múltiplos** princípios SOLID simultaneamente:

```typescript
// ❌ Viola S, O, D
class UserManager {  // SRP: múltiplas responsabilidades
  processUser(userId: string) {  // DIP: instancia concretas
    const db = new MySQLDatabase();  // DIP violado
    const user = db.getUser(userId);

    if (user.type === 'premium') {  // OCP violado: if/type
      this.processPremium(user);
    } else if (user.type === 'basic') {
      this.processBasic(user);
    }
  }

  processPremium(user: User) { /* ... */ }
  processBasic(user: User) { /* ... */ }
  sendEmail(user: User) { /* ... */ }  // SRP: responsabilidade extra
  logActivity(user: User) { /* ... */ }  // SRP: responsabilidade extra
}
```

✅ **Correto**: cada violação deve ser corrigida aplicando o princípio correspondente.

## Fundamentação

SOLID forma a base da arquitetura limpa e testável:

- **SRP + ISP**: reduzem acoplamento, facilitam testes isolados
- **OCP + LSP**: permitem extensão sem modificação, garantem substituibilidade
- **DIP**: inverte dependências, permitindo injeção e mocking

### Interação entre Princípios

```
DIP ─────> permite ─────> OCP
 │                         │
 └──> suporta ──> LSP ─────┘
      │
      └──> requer ──> ISP
                      │
                      └──> reforça ──> SRP
```

## Exemplos

### ✅ Todos os 5 Princípios Aplicados

```typescript
// S: Uma responsabilidade - processar pedidos
// O: Aberto para extensão via Strategy
// L: Subclasses de PaymentStrategy são substituíveis
// I: Interface PaymentStrategy é específica
// D: Depende de abstração (PaymentStrategy), não concreta
class OrderProcessor {
  constructor(
    private readonly paymentStrategy: PaymentStrategy,  // D: abstração
    private readonly orderRepository: OrderRepository   // D: abstração
  ) {}

  process(order: Order): void {  // S: única responsabilidade
    this.validateOrder(order);
    this.paymentStrategy.pay(order);  // O: extensível via Strategy
    this.orderRepository.save(order);
  }

  private validateOrder(order: Order): void {
    if (!order.isValid()) {
      throw new InvalidOrderError();
    }
  }
}

// I: Interface específica para pagamento
interface PaymentStrategy {  // I: 1 método = ISP
  pay(order: Order): void;
}

// L: Substituível por PaymentStrategy
class CreditCardPayment implements PaymentStrategy {
  pay(order: Order): void {
    // Implementação específica
  }
}

// L: Substituível por PaymentStrategy
class PayPalPayment implements PaymentStrategy {
  pay(order: Order): void {
    // Implementação específica
  }
}
```

## Links para Rules deMGoncalves

- **S**: [010 - Princípio de Responsabilidade Única](../../rules/010_principio-responsabilidade-unica.md)
- **O**: [011 - Princípio Aberto/Fechado](../../rules/011_principio-aberto-fechado.md)
- **L**: [012 - Princípio de Substituição de Liskov](../../rules/012_principio-substituicao-liskov.md)
- **I**: [013 - Princípio de Segregação de Interfaces](../../rules/013_principio-segregacao-interfaces.md)
- **D**: [014 - Princípio de Inversão de Dependência](../../rules/014_principio-inversao-dependencia.md)

**Skills relacionadas:**
- [`object-calisthenics`](../object-calisthenics/SKILL.md) — complementa: OC aplica SOLID em nível tático
- [`package-principles`](../package-principles/SKILL.md) — depende: package principles estendem SOLID para módulos
- [`clean-code`](../clean-code/SKILL.md) — reforça: SOLID é pilar do Clean Code

---

**Criada em**: 2026-04-01
**Versão**: 1.0.0
