# Rule 3 — Encapsulamento de Primitivos

**Rule deMGoncalves:** CRIACIONAL-003
**Pergunta:** Este primitivo representa um conceito de domínio?

## O que é

Exige que tipos primitivos (como `number`, `boolean`) e a classe `String` que representam conceitos de domínio (ex: Email, CPF, Moeda) sejam encapsulados em seus próprios Value Objects imutáveis.

## Quando Aplicar

- Método recebe `string` para Email, CPF, URL
- Método recebe `number` para Moeda, Percentual, ID
- Método recebe `string` repetidamente nos mesmos contextos
- Validação do primitivo é duplicada em múltiplos locais

## ❌ Violação

```typescript
class UserService {
  createUser(email: string, cpf: string): User {
    // Validação duplicada em múltiplos locais
    if (!email.includes('@')) throw new Error('Invalid email');
    if (cpf.length !== 11) throw new Error('Invalid CPF');
    // ...
  }
}
```

## ✅ Correto

```typescript
class Email {
  private readonly value: string;

  constructor(email: string) {
    if (!email.includes('@')) {
      throw new Error('Invalid email');
    }
    this.value = email;
    Object.freeze(this);
  }

  toString(): string {
    return this.value;
  }
}

class CPF {
  private readonly value: string;

  constructor(cpf: string) {
    if (cpf.length !== 11) {
      throw new Error('Invalid CPF');
    }
    this.value = cpf;
    Object.freeze(this);
  }

  toString(): string {
    return this.value;
  }
}

class UserService {
  createUser(email: Email, cpf: CPF): User {
    // Validação já feita no construtor dos Value Objects
  }
}
```

## Exceções

- **Primitivos Genéricos**: Contadores (`i`, `index`), booleanos de controle (`isValid`), deltas temporais

## Related Rules

- [008 - Proibição de Getters/Setters](rule-08-no-getters-setters.md): reforça
- [009 - Tell, Don't Ask](rule-09-tell-dont-ask.md): reforça
- [024 - Proibição de Constantes Mágicas](../../rules/024_proibicao-constantes-magicas.md): reforça
