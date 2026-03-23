---
titulo: Acoplamento — Dependências Externas como Componente ICP
aliases:
  - Acoplamento ICP
  - Coupling
  - Dependências Externas
tipo: conceito
origem: cdd
tags:
  - cdd
  - icp
  - acoplamento
  - coupling
  - dependencias
relacionados:
  - "[[calculo-icp]]"
  - "[[componente-responsabilidades]]"
  - "[[005_dependency-inversion-principle]]"
criado: 2026-03-23
---

# Acoplamento — Dependências Externas como Componente ICP

*Coupling*

---

## Definição

**Acoplamento** é o quarto componente do ICP. Mede o número de **dependências externas diretas** que uma função ou método utiliza — classes, módulos, serviços ou variáveis globais que a função precisa conhecer para funcionar.

Diferentemente dos outros componentes, o acoplamento mede **conhecimento externo** necessário: o desenvolvedor precisa entender não apenas o código da função, mas também o contrato de cada dependência utilizada.

## Como Calcular

Contar o número de **colaboradores externos distintos** referenciados diretamente no corpo da função. Incluem:

- Instâncias de classes externas (`userRepository`, `emailService`)
- Módulos importados utilizados (`bcrypt`, `logger`, `dayjs`)
- Variáveis globais ou de escopo externo acessadas
- Funções externas chamadas diretamente

**Não contam:**
- Parâmetros recebidos (já são dependências explícitas no contrato)
- Literais e constantes locais
- Funções do próprio módulo/classe

## Tabela de Pontuação

| Dependências externas | Pontos ICP |
|-----------------------|------------|
| 0–2 | 0 |
| 3–5 | 1 |
| 6+ | 2 |

## Exemplos

### 0–2 dependências → +0 ICP

```javascript
// 0 dependências externas: apenas operações internas
function calculateTotal(items) {
  return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
}

// 1 dependência (dayjs) — dentro do limite
function formatDate(date) {
  return dayjs(date).format('DD/MM/YYYY'); // dayjs: +1
}
```

### 3–5 dependências → +1 ICP

```javascript
// 3 dependências: database, logger, emailService
async function deactivateUser(userId) {
  const user = await database.users.findById(userId);   // database: +1
  user.active = false;
  await database.users.update(user);
  await emailService.sendDeactivation(user.email);      // emailService: +1
  logger.info('user_deactivated', { userId });           // logger: +1
}
// Acoplamento = 3 dependências → +1 ICP
```

### 6+ dependências → +2 ICP

```javascript
// 7 dependências: acoplamento crítico
async function processCheckout(cartId) {
  const cart = await cartRepository.findById(cartId);      // +1
  const user = await userRepository.findById(cart.userId); // +1
  const prices = await priceService.calculate(cart);       // +1
  const payment = await paymentGateway.charge(user, prices.total); // +1
  const order = await orderRepository.create(cart, payment); // +1
  await inventoryService.reserve(cart.items);              // +1
  await emailService.sendConfirmation(user, order);        // +1
}
// Acoplamento = 7 dependências → +2 ICP
```

## Por que Acoplamento Alto Aumenta a Carga Cognitiva

Cada dependência externa é um **contrato adicional** que o desenvolvedor precisa conhecer para:

1. Entender o que a função faz (o que cada colaborador retorna ou modifica)
2. Testar a função em isolamento (precisa mockar cada dependência)
3. Debugar falhas (precisa rastrear qual dependência causou o problema)
4. Modificar a função (precisa verificar o impacto em cada dependência)

Com 7 dependências, um bug pode ter 7 fontes diferentes — o desenvolvedor precisa investigar todas.

## Como Reduzir Acoplamento

### Dependency Injection (Inversão de Dependência)

Mova dependências para o construtor da classe, deixando os métodos mais focados:

```javascript
// Antes: método com 4 dependências diretas
class OrderService {
  async create(data) {
    const user = await userRepository.findById(data.userId);    // +1
    const order = buildOrder(data, user);
    await orderRepository.save(order);                          // +1
    await paymentGateway.charge(user, order.total);             // +1
    await emailService.sendConfirmation(user, order);           // +1
  }
}
// Acoplamento do método = 4 → +1 ICP

// Depois: dependências injetadas, método com 0 dependências diretas
class OrderService {
  constructor(
    private userRepo,       // declarado uma vez
    private orderRepo,
    private payment,
    private email,
  ) {}

  async create(data) {
    const user = await this.userRepo.findById(data.userId);
    const order = buildOrder(data, user);
    await this.orderRepo.save(order);
    await this.payment.charge(user, order.total);
    await this.email.sendConfirmation(user, order);
  }
}
// Acoplamento do método = 0 (usa this.*, não referências globais) → +0 ICP
```

**Nota:** No ICP, dependências injetadas via `this.*` em construtores não contam como acoplamento do método — o acoplamento foi deslocado para o construtor (que é o lugar correto para declará-lo).

### Facade Pattern

Agrupe múltiplas dependências em uma fachada especializada:

```javascript
// Antes: 5 dependências no método de notificação
async function notifyOrderCompletion(order, user) {
  await emailService.send(user.email, 'order_complete', order);  // +1
  await smsService.send(user.phone, 'Pedido enviado!');           // +1
  await pushService.notify(user.deviceToken, order);              // +1
  await analyticsService.track('order_shipped', order);           // +1
  await slackBot.post('#orders', `Pedido ${order.id} enviado`);  // +1
}

// Depois: 1 dependência (fachada)
async function notifyOrderCompletion(order, user) {
  await notificationFacade.orderShipped(order, user); // +1
}
// O detalhe de COMO notificar fica encapsulado na fachada
```

## Acoplamento vs. Responsabilidades

Os dois componentes são complementares:

- **Responsabilidades** mede *o quê* a função faz (dimensões de trabalho)
- **Acoplamento** mede *com quem* a função colabora (dependências de conhecimento)

Uma função com 5 responsabilidades quase sempre terá 5+ dependências — os problemas se alimentam mutuamente. Refatorar um geralmente melhora o outro.

## Detecção Automática

Biome: sem regra nativa para contagem de dependências externas por método. Identificar via revisão de código contando referências a colaboradores externos no corpo da função.

## Relacionados

- [[calculo-icp]] — Acoplamento é o quarto componente do ICP
- [[componente-responsabilidades]] — diretamente correlacionado
- [[005_dependency-inversion-principle|Princípio da Inversão de Dependência]] — a solução estrutural para alto acoplamento
- [[restricao-imports-relativos]] — imports relativos aumentam acoplamento frágil à estrutura de pastas
- [[proibicao-anti-padrao-blob]] — Blobs têm acoplamento máximo por definição
