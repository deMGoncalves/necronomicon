---
titulo: Primitive Obsession (Obsessão por Primitivos)
aliases:
  - Primitive Obsession
  - Obsessão por Primitivos
tipo: anti-pattern
id: AP-14
severidade: 🟡 Médio
origem: refactoring
tags: [anti-pattern, estrutural, dominio, tipos]
criado: 2026-03-20
relacionados:
  - "[[003_primitive-encapsulation]]"
  - "[[data-clumps]]"
  - "[[proibicao-constantes-magicas]]"
---

# Primitive Obsession (Obsessão por Primitivos)

*Primitive Obsession*

---

## Definição

Usar tipos primitivos (`string`, `number`, `boolean`) para representar conceitos de domínio que deveriam ser objetos com comportamento próprio. CEP como `string`, dinheiro como `number`, status como `boolean`.

## Sintomas

- Parâmetros tipo `(string email, string phone, string zipCode)` em vez de objetos
- Validação do mesmo formato espalhada em vários lugares (`/\d{8}/` para CEP)
- Magic Numbers que representam estados: `status === 1`, `type === 'A'`
- Arrays de primitivos onde objetos seriam mais descritivos

## Causas Raiz

- Resistência a criar classes "só para guardar um valor"
- Falta de familiaridade com Value Objects
- "Vai complicar" — percepção equivocada de que primitivos são mais simples

## Consequências

- Validação duplicada: cada uso do primitivo precisa validar o formato
- Sem comportamento encapsulado: operações sobre o valor ficam espalhadas
- Erros de tipo: trocar `(email, phone)` por `(phone, email)` não é detectado pelo compilador

## Solução / Refatoração

Criar **Value Objects**: classes simples que encapsulam o valor e suas regras (validação, formatação, comparação). Imutáveis por natureza.

## Exemplo — Problemático

```javascript
// ❌ CPF como string solta — validação duplicada em N lugares
function createUser(name, cpf, email) {
  if (!/^\d{11}$/.test(cpf)) throw new Error('CPF inválido');
  // ... mesma validação em updateUser, validateDocument, etc.
}
```

## Exemplo — Refatorado

```javascript
// ✅ CPF como Value Object — validação encapsulada uma vez
class CPF {
  constructor(value) {
    if (!/^\d{11}$/.test(value)) throw new Error('CPF inválido');
    this.value = value;
  }
  format() { return `${this.value.slice(0,3)}.${this.value.slice(3,6)}.${this.value.slice(6,9)}-${this.value.slice(9)}`; }
}

function createUser(name, cpf, email) {
  // CPF já vem validado — quem instancia CPF garante a validade
}
```

## Rules que Previnem

- [[003_primitive-encapsulation]] — encapsulação de primitivos (Object Calisthenics)
- [[proibicao-constantes-magicas]] — constantes mágicas são Primitive Obsession em status

## Relacionados

- [[data-clumps]] — grupos de primitivos que andam juntos são candidatos a Value Objects
