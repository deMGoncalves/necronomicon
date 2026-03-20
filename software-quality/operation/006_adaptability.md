# Adaptability (Adaptabilidade)

**Dimensão**: Operação
**Severidade Default**: 🟠 Important

---

## Pergunta Chave

**Ele é configurável?**

## Definição

A facilidade com que o software pode ser modificado para atender diferentes necessidades de usuários, ambientes ou requisitos sem alteração do código fonte. Adaptabilidade inclui configurabilidade, parametrização e extensibilidade via plugins.

## Critérios de Verificação

- [ ] Comportamentos configuráveis via variáveis de ambiente
- [ ] Feature flags para funcionalidades opcionais
- [ ] Internacionalização (i18n) quando necessário
- [ ] Temas/estilos customizáveis
- [ ] Limites e thresholds parametrizáveis
- [ ] Extensibilidade via plugins/hooks

## Indicadores de Problema

### Exemplo 1: Valores Hardcoded

```javascript
// ❌ Não adaptável - valores fixos no código
function shouldRetry(attempts) {
  return attempts < 3; // Sempre 3 tentativas
}

function getTimeout() {
  return 5000; // Sempre 5 segundos
}

// ✅ Adaptável - valores configuráveis
function shouldRetry(attempts) {
  const maxRetries = config.get('MAX_RETRIES', 3);
  return attempts < maxRetries;
}

function getTimeout() {
  return config.get('REQUEST_TIMEOUT', 5000);
}
```

### Exemplo 2: Feature Flag Ausente

```javascript
// ❌ Não adaptável - funcionalidade sempre ativa
function processOrder(order) {
  sendEmailNotification(order); // Sempre envia
  sendSMSNotification(order);   // Sempre envia
  return order;
}

// ✅ Adaptável - features controladas por flags
function processOrder(order) {
  if (features.isEnabled('EMAIL_NOTIFICATIONS')) {
    sendEmailNotification(order);
  }
  if (features.isEnabled('SMS_NOTIFICATIONS')) {
    sendSMSNotification(order);
  }
  return order;
}
```

### Exemplo 3: Textos Hardcoded

```javascript
// ❌ Não adaptável - textos fixos
function showError() {
  alert('An error occurred. Please try again.');
}

// ✅ Adaptável - textos internacionalizados
function showError() {
  alert(i18n.t('errors.generic'));
}

// Ou com template
function showError() {
  alert(messages.get('ERROR_GENERIC'));
}
```

### Exemplo 4: Lógica Sem Extensibilidade

```javascript
// ❌ Não adaptável - processadores fixos
function processPayment(payment) {
  if (payment.method === 'credit') {
    return processCreditCard(payment);
  } else if (payment.method === 'debit') {
    return processDebitCard(payment);
  }
  throw new UnsupportedMethodError();
}

// ✅ Adaptável - registry de processadores
const paymentProcessors = new Map();

function registerProcessor(method, processor) {
  paymentProcessors.set(method, processor);
}

function processPayment(payment) {
  const processor = paymentProcessors.get(payment.method);
  if (!processor) {
    throw new UnsupportedMethodError(payment.method);
  }
  return processor.process(payment);
}
```

## Sinais de Alerta em Code Review

1. **Números mágicos** usados em condições ou cálculos
2. **Strings de texto** diretamente no código (não em arquivos de i18n)
3. **if/switch** para tipos que crescem frequentemente
4. **URLs/endpoints** hardcoded
5. **Regras de negócio** que variam por cliente fixas no código
6. **Configurações** que deveriam ser por ambiente fixas no código

## Impacto Quando Violado

| Contexto | Impacto |
|----------|---------|
| Timeout fixo | Não funciona em redes lentas |
| Texto hardcoded | Não pode ser traduzido |
| Features fixas | Deploy necessário para desligar |
| Regras fixas | Código diferente por cliente |

## Calibração de Severidade

| Situação | Severidade |
|----------|------------|
| Credenciais/URLs de ambiente hardcoded | 🔴 Blocker |
| Lógica que varia por cliente hardcoded | 🟠 Important |
| Timeout/retry sem configuração | 🟠 Important |
| Textos UI sem i18n | 🟡 Suggestion |

## Codetags Sugeridos

```javascript
// CONFIG: Este valor deveria ser configurável via ambiente
// CONFIG: Considerar feature flag para esta funcionalidade

// TODO: Extrair textos para arquivo de i18n
// TODO: Implementar registry para extensibilidade
```

## Exemplo de Comentário em Review

```
El timeout está hardcodeado:

const TIMEOUT = 5000; // ❌ Fijo

Mejor hacerlo configurable:

const TIMEOUT = config.get('API_TIMEOUT', 5000);

Así se puede ajustar por ambiente sin redeploy.

🟠 Importante - mejorar adaptabilidad
```

## Rules Relacionadas

- [twelve-factor/003 - Config via Environment](../../twelve-factor/003_configuracoes-via-ambiente.md)
- [clean-code/004 - Magic Constants](../../clean-code/proibicao-constantes-magicas.md)
- [solid/002 - Open/Closed Principle](../../solid/002_principio-aberto-fechado.md)

## Patterns Relacionados

- [gof/behavioral/009 - Strategy](../../gof/behavioral/009_strategy.md): para comportamentos intercambiáveis
- [gof/creational/003 - Factory Method](../../gof/creational/003_factory-method.md): para criação configurável
- [gof/structural/002 - Bridge](../../gof/structural/002_bridge.md): para desacoplar abstração de implementação

---

**Criada em**: 2026-03-18
**Versão**: 1.0
