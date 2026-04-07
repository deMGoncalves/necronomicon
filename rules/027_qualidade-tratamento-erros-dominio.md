# Error Handling Quality: Use Domain Exceptions

**ID**: COMPORTAMENTAL-027
**Severity**: 🟠 High
**Category**: Behavioral

---

## What It Is

Requires that business logic use **exceptions (errors)** to report problems, instead of return codes or null values. Exceptions must be domain-specific (e.g., `UserNotFoundError`).

## Why It Matters

Error codes or null values (e.g., `return null`) force the client to verify the return on every call, spreading error logic. Exceptions ensure the error is not ignored and provide stack trace.

## Objective Criteria

- [ ] Business methods (Services, Use Cases) must return valid types or throw exception, **prohibiting** `return null` or `return undefined`.
- [ ] Using empty `catch` or one that only logs the error and continues the flow is prohibited (must rethrow or handle).
- [ ] Thrown exceptions must be customized for the domain (e.g., extend a `BaseDomainError` class).

## Allowed Exceptions

- **Parse/Utility Functions**: Low-level functions that can return `null` or `undefined` to indicate read or conversion failure.

## How to Detect

### Manual

Search for `return null`, `return -1`, or `catch (e) {}` in business code.

### Automatic

ESLint: `no-return-null`, `no-empty-catch`.

## Related To

- [002 - Prohibition of ELSE Clause](002_proibicao-clausula-else.md): complements
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): reinforces
- [028 - Asynchronous Exception Handling](028_tratamento-excecao-assincrona.md): reinforces
- [036 - Restriction of Functions with Side Effects](036_restricao-funcoes-efeitos-colaterais.md): reinforces
- [050 - Logs as Event Stream](050_logs-fluxo-eventos.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
