---
name: c4model
description: Template C4 Model com 4 níveis de abstração para visualização arquitetural (Context, Container, Component, Code). Use quando @architect precisar criar ou atualizar docs/c4/ para comunicar arquitetura a diferentes públicos — ao criar diagramas de contexto, container, componente ou código.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
  category: documentation
---

# C4 Model

4 níveis de abstração progressiva para comunicar arquitetura a diferentes públicos.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Fase 4 (Docs) após implementação; ao comunicar arquitetura para públicos diferentes (stakeholders, devs); ao criar ou atualizar arquivos em `docs/c4/` |
| **Prerequisites** | Sistema ou feature implementado; nomes consistentes de sistema, containers e componentes definidos; familiaridade com o público-alvo de cada nível |
| **Constraints** | Não misturar níveis num mesmo diagrama; Nível 4 (Code) só quando estritamente necessário; idioma pt-BR obrigatório |
| **Scope** | 4 níveis de diagramas em `docs/c4/`: System Context (L1), Container (L2), Component (L3), Code (L4) — cada nível com público e pergunta-chave definidos |

---

## Quando Usar

- **Fase 4 (Docs):** @architect cria/atualiza docs/c4/ após implementação
- **Nível 1-2:** para stakeholders (negócio, gestão)
- **Nível 3-4:** para desenvolvedores (implementação)

## Os 4 Níveis

| Nível | Arquivo | Público | Pergunta-chave |
|-------|---------|---------|----------------|
| 1 — System Context | 01_system_context.md | Todos | O que o sistema faz e com quem se conecta? |
| 2 — Container | 02_container.md | Técnico | Que tecnologia compõe cada parte? |
| 3 — Component | 03_component.md | Dev | Como este serviço está organizado internamente? |
| 4 — Code | 04_code.md | Dev | Como este componente está implementado? |

## Templates

Veja os templates em references/:
- [references/01_system-context.md](references/01_system-context.md) → template Nível 1
- [references/02_container.md](references/02_container.md) → template Nível 2
- [references/03_component.md](references/03_component.md) → template Nível 3
- [references/04_code.md](references/04_code.md) → template Nível 4

## Convenções

- Nomenclatura consistente entre níveis (mesmo nome para system/container/component)
- Nível 1-2: linguagem simples, sem jargão técnico
- Nível 3-4: tipos, interfaces, patterns específicos
- Idioma: português brasileiro
- Relacionado com: arc42 §5 (Building Block View)

## Exemplos

```markdown
// ❌ Bad — um único diagrama tentando mostrar tudo
[diagrama caótico misturando usuários finais, sistemas externos, APIs internas,
 banco de dados, código de classes — tudo num único nível sem separação de concerns]

Diagrama contém:
- User → Frontend → AuthService → UserRepository → PostgreSQL
- Admin → Dashboard → OrderService → PaymentGateway (externo)
- Mobile App → API Gateway → Logger → Kafka
Público: CTO? Dev? Stakeholder? — ninguém entende

---

// ✅ Good — C4 em 4 níveis progressivos de abstração

## Nível 1 — System Context (para todos: CTO, stakeholders, negócio)

```
[User] --usa--> [Sistema E-commerce]
[Sistema E-commerce] --integra--> [Stripe Payment Gateway]
[Sistema E-commerce] --integra--> [SendGrid Email Service]
```

Pergunta: "O que o sistema faz?" → Venda de produtos com pagamento online.

---

## Nível 2 — Container (para arquitetos, tech leads)

```
[React SPA Frontend] --chama HTTP--> [Node.js Backend API]
[Backend API] --lê/escreve--> [PostgreSQL Database]
[Backend API] --publica eventos--> [RabbitMQ]
[Worker Service] --consome--> [RabbitMQ]
```

Pergunta: "Que tecnologias compõem o sistema?"
→ React, Node.js, PostgreSQL, RabbitMQ

---

## Nível 3 — Component (para desenvolvedores)

Node.js Backend API contém:
- AuthController (autentica usuários)
- OrderService (processa pedidos)
- PaymentGateway (integra com Stripe)
- UserRepository (acessa tabela de usuários)

Pergunta: "Como o backend está organizado internamente?"
→ Controllers, Services, Repositories

---

## Nível 4 — Code (para desenvolvedores — apenas se necessário)

```typescript
class OrderService {
  constructor(
    private repo: OrderRepository,
    private payment: PaymentGateway
  ) {}

  async createOrder(order: Order): Promise<OrderId> {
    const savedOrder = await this.repo.save(order)
    await this.payment.charge(order.total)
    return savedOrder.id
  }
}
```

Pergunta: "Como OrderService está implementado?"
→ DIP: depende de abstrações (Repository, Gateway)
```

## Justificativa

- c4model.com: criado por Simon Brown
- Complementa arc42 com visualizações por nível de abstração
