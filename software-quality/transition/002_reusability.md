# Reusability (Reusabilidade)

**Dimensão**: Transição
**Severidade Default**: 🟠 Important

---

## Pergunta Chave

**Pode ser usado em outro contexto?**

## Definição

O grau em que um módulo ou componente pode ser reutilizado em outros sistemas ou contextos além daquele para o qual foi originalmente desenvolvido. Alta reusabilidade significa que componentes são genéricos, bem documentados e têm interfaces claras.

## Critérios de Verificação

- [ ] Código segue princípio DRY (Don't Repeat Yourself)
- [ ] Componentes têm responsabilidade única
- [ ] Interfaces bem definidas e documentadas
- [ ] Sem dependências desnecessárias
- [ ] Baixo acoplamento com contexto específico
- [ ] Configurabilidade via parâmetros

## Indicadores de Problema

### Exemplo 1: Código Duplicado

```javascript
// ❌ Não reutilizável - lógica duplicada
// file1.js
function validateUserEmail(email) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
}

// file2.js
function checkEmailFormat(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

// ✅ Reutilizável - função única compartilhada
// shared/validators.js
export function isValidEmail(email) {
  const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return EMAIL_REGEX.test(email);
}
```

### Exemplo 2: Componente Específico Demais

```javascript
// ❌ Não reutilizável - muito específico
function ProductCardForHomePage({ product }) {
  return (
    <div className="home-product-card">
      <h2>{product.name}</h2>
      <p className="home-price">${product.price}</p>
      <button onClick={() => addToHomeCart(product)}>
        Adicionar
      </button>
    </div>
  );
}

// ✅ Reutilizável - genérico e configurável
function ProductCard({ product, onAction, actionLabel, className }) {
  return (
    <div className={`product-card ${className}`}>
      <h2>{product.name}</h2>
      <p className="price">${product.price}</p>
      <button onClick={() => onAction(product)}>
        {actionLabel}
      </button>
    </div>
  );
}
```

### Exemplo 3: Acoplamento com Contexto

```javascript
// ❌ Não reutilizável - acoplado ao contexto
class OrderValidator {
  validate(order) {
    const user = getCurrentLoggedUser(); // Depende de contexto global
    const config = AppConfig.getInstance(); // Singleton

    if (order.total > config.maxOrderAmount) {
      return false;
    }
    return user.canOrder;
  }
}

// ✅ Reutilizável - dependências explícitas
class OrderValidator {
  constructor(config) {
    this.config = config;
  }

  validate(order, user) {
    if (order.total > this.config.maxOrderAmount) {
      return false;
    }
    return user.canOrder;
  }
}
```

### Exemplo 4: Funções com Muitas Responsabilidades

```javascript
// ❌ Não reutilizável - faz muitas coisas
async function processAndSaveAndNotifyOrder(orderData) {
  const validated = validateOrder(orderData);
  const calculated = calculateTotals(validated);
  const saved = await db.orders.save(calculated);
  await emailService.send(saved.customerEmail);
  return saved;
}

// ✅ Reutilizável - funções focadas
function validateOrder(order) { /* ... */ }
function calculateTotals(order) { /* ... */ }

// Composição no ponto de uso
async function processOrder(order, { repository, notifier }) {
  const validated = validateOrder(order);
  const calculated = calculateTotals(validated);
  const saved = await repository.save(calculated);
  await notifier.notify(saved);
  return saved;
}
```

### Exemplo 5: Utilitário com Dependência Oculta

```javascript
// ❌ Não reutilizável - dependência oculta de domínio
// utils/formatters.js
import { CompanySettings } from '../domain/settings';

export function formatCurrency(amount) {
  const settings = CompanySettings.get();
  return new Intl.NumberFormat(settings.locale, {
    style: 'currency',
    currency: settings.currency
  }).format(amount);
}

// ✅ Reutilizável - parâmetros explícitos
// utils/formatters.js
export function formatCurrency(amount, { locale, currency }) {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency
  }).format(amount);
}
```

## Sinais de Alerta em Code Review

1. **Código duplicado** em múltiplos arquivos
2. **Componentes** com nomes específicos de página/feature
3. **Imports** de contexto global em utilitários
4. **Funções** que fazem validação + persistência + notificação
5. **Nomes** que indicam local de uso (`HomePageButton`)
6. **Parâmetros** não configuráveis quando deveriam ser

## Impacto Quando Violado

| Contexto | Impacto |
|----------|---------|
| Código duplicado | Bug corrigido em um lugar apenas |
| Componente específico | Precisa criar outro similar |
| Acoplamento contexto | Não pode extrair para lib |
| Muitas responsabilidades | Impossível reusar parcialmente |

## Calibração de Severidade

| Situação | Severidade |
|----------|------------|
| Lógica de negócio duplicada | 🟠 Important |
| Utilitário acoplado a domínio | 🟠 Important |
| Componente UI específico demais | 🟡 Suggestion |
| Nomenclatura específica de contexto | 🟡 Suggestion |

## Codetags Sugeridos

```javascript
// DRY: Esta lógica está duplicada em outro arquivo
// REUSE: Componente muito específico - generalizar

// TODO: Extrair para módulo compartilhado
// TODO: Remover dependência de contexto global
```

## Exemplo de Comentário em Review

```
Esta lógica de validación de email está duplicada:

// En user-service.js
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// En contact-form.js
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

Mejor extraerla a un módulo compartido:

// shared/validators.js
export const isValidEmail = (email) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);

🟠 Importante - principio DRY
```

## Rules Relacionadas

- [clean-code/001 - DRY](../../clean-code/proibicao-duplicacao-logica.md)
- [object-calisthenics/003 - Encapsulation](../../object-calisthenics/003_encapsulamento-primitivos.md)
- [solid/001 - Single Responsibility](../../solid/001_principio-responsabilidade-unica.md)

## Patterns Relacionados

- [gof/behavioral/010 - Template Method](../../gof/behavioral/010_template-method.md): para reusar algoritmo com variações
- [gof/structural/003 - Composite](../../gof/structural/003_composite.md): para compor objetos reutilizáveis
- [poeaa/base/001 - Layer Supertype](../../poeaa/base/001_layer-supertype.md): para compartilhar comportamento

---

**Criada em**: 2026-03-18
**Versão**: 1.0
