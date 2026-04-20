---
name: c4model
description: Template C4 Model com 4 níveis de abstração para visualização arquitetural (Context, Container, Component, Code). Use quando @architect precisa criar ou atualizar docs/c4/ para comunicar arquitetura a diferentes audiências — ao criar diagramas de contexto, container, componente ou código.
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
  category: documentation
---

# C4 Model

4 níveis de abstração progressiva para comunicar arquitetura a diferentes audiências.

---

## Quando Usar

- **Fase 4 (Docs):** @architect cria/atualiza docs/c4/ após implementação
- **Level 1-2:** para stakeholders (negócio, gestão)
- **Level 3-4:** para desenvolvedores (implementação)

## Os 4 Níveis

| Level | Arquivo | Audiência | Pergunta-chave |
|-------|---------|-----------|----------------|
| 1 — System Context | 01_system_context.md | Todos | O que o sistema faz e com quem se conecta? |
| 2 — Container | 02_container.md | Técnico | Qual tecnologia compõe cada parte? |
| 3 — Component | 03_component.md | Dev | Como este serviço é organizado internamente? |
| 4 — Code | 04_code.md | Dev | Como este componente é implementado? |

## Templates

Consulte os templates em references/:
- [references/01_system-context.md](references/01_system-context.md) → template Level 1
- [references/02_container.md](references/02_container.md) → template Level 2
- [references/03_component.md](references/03_component.md) → template Level 3
- [references/04_code.md](references/04_code.md) → template Level 4

## Convenções

- Nomenclatura consistente entre níveis (mesmo nome de sistema/container/componente)
- Level 1-2: linguagem simples, sem jargão técnico
- Level 3-4: tipos, interfaces, padrões específicos
- Idioma: português brasileiro
- Relacionada com: arc42 §5 (Building Block View)

## Exemplos

```markdown
// ❌ Ruim — um único diagrama tentando mostrar tudo
[diagrama caótico misturando usuários finais, sistemas externos, APIs internas,
 banco de dados, código de classes — tudo em um único nível sem separação de concerns]

Diagrama contém:
- Usuário → Frontend → AuthService → UserRepository → PostgreSQL
- Admin → Dashboard → OrderService → PaymentGateway (externo)
- Mobile App → API Gateway → Logger → Kafka
Audiência: CTO? Dev? Stakeholder? — ninguém entende

---

// ✅ Bom — C4 em 4 níveis progressivos de abstração

## Nível 1 — System Context (para todos: CTO, stakeholders, negócio)

```
[Usuário] --usa--> [Sistema E-commerce]
[Sistema E-commerce] --integra--> [Gateway de Pagamento Stripe]
[Sistema E-commerce] --integra--> [Serviço de Email SendGrid]
```

Pergunta: "O que o sistema faz?" → Venda de produtos com pagamento online.

---

## Nível 2 — Container (para arquitetos, tech leads)

```
[Frontend React SPA] --chamadas HTTP--> [Backend API Node.js]
[Backend API] --lê/escreve--> [PostgreSQL Database]
[Backend API] --publica eventos--> [RabbitMQ]
[Worker Service] --consome--> [RabbitMQ]
```

Pergunta: "Quais tecnologias compõem o sistema?"
→ React, Node.js, PostgreSQL, RabbitMQ

---

## Nível 3 — Component (para desenvolvedores)

Backend API Node.js contém:
- AuthController (autentica usuários)
- OrderService (processa pedidos)
- PaymentGateway (integra com Stripe)
- UserRepository (acessa tabela users)

Pergunta: "Como o backend é organizado internamente?"
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

Pergunta: "Como OrderService é implementado?"
→ DIP: depende de abstrações (Repository, Gateway)
```

## Fundamentação

- c4model.com: criado por Simon Brown
- Complementa arc42 com visualizações por nível de abstração
