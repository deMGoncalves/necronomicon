---
titulo: Responsabilidades — Violações de SRP como Componente ICP
aliases:
  - Responsabilidades ICP
  - Número de Responsabilidades
  - SRP no ICP
tipo: conceito
origem: cdd
tags:
  - cdd
  - icp
  - responsabilidades
  - srp
  - solid
relacionados:
  - "[[calculo-icp]]"
  - "[[componente-cc-base]]"
  - "[[componente-acoplamento]]"
  - "[[001_single-responsibility-principle]]"
criado: 2026-03-23
---

# Responsabilidades — Violações de SRP como Componente ICP

*Single Responsibility Principle no Contexto de ICP*

---

## Definição

**Responsabilidades** é o terceiro componente do ICP. Mede quantas **responsabilidades distintas** uma função ou método executa simultaneamente — uma operacionalização direta do Princípio da Responsabilidade Única (SRP) no contexto de carga cognitiva.

Uma função com múltiplas responsabilidades força o desenvolvedor a manter em mente vários domínios de conhecimento diferentes ao mesmo tempo, multiplicando a carga cognitiva.

## As 8 Dimensões de Responsabilidade

Uma função pode ter qualquer combinação das seguintes responsabilidades:

| # | Dimensão | Exemplos |
|---|---|---|
| 1 | **Validação de dados** | Verificar campos obrigatórios, formatos, regras de negócio |
| 2 | **Transformação de dados** | Mapear, filtrar, converter formatos, calcular |
| 3 | **Persistência** | `INSERT`, `UPDATE`, `DELETE` em banco de dados ou arquivo |
| 4 | **Consulta** | `SELECT`, `GET`, buscar dados de repositório ou API |
| 5 | **Lógica de negócio** | Aplicar regras de domínio, calcular preços, avaliar elegibilidade |
| 6 | **Formatação / Apresentação** | Serializar para JSON, formatar datas, montar HTML |
| 7 | **Logging / Auditoria** | Registrar eventos, enviar métricas, auditoria de segurança |
| 8 | **Tratamento de erros** | Capturar exceções, mapear para erros de domínio, relançar |

## Como Calcular

Contar quantas das 8 dimensões aparecem **simultaneamente** no corpo da função:

```javascript
function registerUser(data) {
  // 1. Validação
  if (!data.email || !data.email.includes('@')) {
    throw new InvalidEmailError(data.email);
  }

  // 2. Transformação
  const hashedPassword = bcrypt.hash(data.password, 10);
  const user = { email: data.email.toLowerCase(), password: hashedPassword };

  // 3. Persistência
  const saved = database.users.insert(user);

  // 4. Logging
  logger.info('user_registered', { userId: saved.id, email: saved.email });

  // 5. Consulta (para verificar unicidade — regra de negócio)
  const exists = database.users.findByEmail(data.email);
  if (exists) throw new DuplicateEmailError(data.email);

  return saved;
}
```

**Contagem:** validação (1) + transformação (2) + persistência (3) + logging (4) + consulta (5) = **5 responsabilidades → +2 pontos ICP**

## Tabela de Pontuação

| Responsabilidades distintas | Pontos ICP |
|-----------------------------|------------|
| 1 | 0 |
| 2–3 | 1 |
| 4–5 | 2 |
| 6+ | 3 |

## Exemplos

### 1 responsabilidade → +0 ICP

```javascript
// Apenas transformação: ICP de responsabilidades = 0
function formatCurrency(amount, currency = 'BRL') {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency,
  }).format(amount);
}
```

### 2–3 responsabilidades → +1 ICP

```javascript
// Validação + Lógica de negócio: ICP de responsabilidades = 1
function calculateDiscount(user, order) {
  if (!user.isPremium) return 0;          // validação
  if (order.total < 100) return 0;        // regra de negócio

  return user.vip ? order.total * 0.3    // lógica de negócio
                  : order.total * 0.1;
}
```

### 4–5 responsabilidades → +2 ICP

```javascript
// Validação + Consulta + Transformação + Persistência + Logging
function createProduct(data) {
  if (!data.name || !data.price) throw new ValidationError(); // validação
  const existing = db.products.findByName(data.name);        // consulta
  if (existing) throw new DuplicateError();

  const product = { ...data, createdAt: new Date() };        // transformação
  const saved = db.products.insert(product);                  // persistência
  logger.info('product_created', { id: saved.id });           // logging

  return saved;
}
```

### 6+ responsabilidades → +3 ICP (God Function)

Qualquer função que executa mais de 5 responsabilidades distintas é praticamente impossível de testar em isolamento e quase certamente viola o SRP de forma grave.

## Por que Múltiplas Responsabilidades Aumentam a Carga Cognitiva

Cada responsabilidade distinta introduz um **domínio de conhecimento** que o desenvolvedor precisa ativar mentalmente:

- Para entender **validação**, precisa conhecer as regras de negócio
- Para entender **persistência**, precisa conhecer o esquema do banco
- Para entender **logging**, precisa conhecer o contrato do logger
- Para entender **transformação**, precisa entender o mapeamento

Quando esses domínios se misturam em uma única função, o desenvolvedor precisa alternar entre eles constantemente — um custo cognitivo chamado *context switching* que é especialmente pesado na memória de trabalho.

## Como Reduzir Responsabilidades

### Separar por Camada

Distribua responsabilidades por funções especializadas:

```javascript
// Antes: 5 responsabilidades em uma função
function createOrder(data) {
  validateOrderData(data);  // ainda acoplado
  const user = db.users.findById(data.userId); // consulta
  const order = buildOrder(data, user); // transformação
  db.orders.insert(order); // persistência
  emailService.sendConfirmation(order); // efeito colateral
  logger.info('order_created', order); // logging
}

// Depois: cada função com 1 responsabilidade
function validateOrderData(data) { /* apenas validação */ }
function buildOrder(data, user) { /* apenas transformação */ }

// O orquestrador tem 1 responsabilidade: coordenar
async function createOrder(data) {
  const validated = validateOrderData(data);
  const user = await userRepository.findById(validated.userId); // consulta
  const order = buildOrder(validated, user);
  return orderRepository.save(order); // persistência + efeitos colaterais no repositório
}
```

### Application Services (CQRS/Hexagonal)

Em arquiteturas mais estruturadas, Use Cases e Application Services são o lugar natural para orquestrar múltiplas responsabilidades — com a diferença de que cada colaborador tem sua responsabilidade única:

```javascript
class CreateOrderUseCase {
  constructor(
    private orderValidator,   // responsável por validação
    private userRepository,   // responsável por consulta
    private orderRepository,  // responsável por persistência
    private emailService,     // responsável por notificação
  ) {}

  // 1 responsabilidade: orquestrar
  async execute(data) {
    const validated = this.orderValidator.validate(data);
    const user = await this.userRepository.findById(validated.userId);
    const order = Order.create(validated, user);
    await this.orderRepository.save(order);
    await this.emailService.sendConfirmation(order);
    return order;
  }
}
```

## Relação com Acoplamento

Múltiplas responsabilidades quase sempre implicam **acoplamento alto**: uma função com 5 responsabilidades tipicamente depende de 5+ colaboradores externos. Os dois componentes do ICP se alimentam mutuamente — reduzir responsabilidades geralmente reduz acoplamento automaticamente.

## Detecção

Biome: sem regra nativa para contagem de responsabilidades. Identificar via revisão de código buscando funções que executam mais de uma das 8 dimensões listadas.

## Relacionados

- [[calculo-icp]] — Responsabilidades é o terceiro componente do ICP
- [[componente-acoplamento]] — correlacionado: mais responsabilidades = mais dependências
- [[001_single-responsibility-principle|Princípio da Responsabilidade Única]] — o princípio SOLID que este componente operacionaliza
- [[restricao-funcoes-efeitos-colaterais]] — efeitos colaterais são responsabilidades ocultas
- [[conformidade-principio-inversao-consulta]] — separar Queries de Commands = 2 responsabilidades vira 1
