# Complete Asynchronous Exception Handling (Promises)

**ID**: COMPORTAMENTAL-028
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What It Is

Requires that all returned Promises be explicitly handled (consumed) with **`await`**, **`.catch()`**, or a result pattern, to prevent *Uncaught Promise Rejections* (uncaught errors).

## Why It Matters

In environments like Node.js, unhandled exceptions in Promises are fatal and crash the main process. Ensures that system **stability** is not compromised by "floating" asynchronous calls or ignored errors.

## Objective Criteria

- [ ] All function calls that return `Promise` must be followed by `await` or `Promise.then().catch()`.
- [ ] Using `async` in a method without having at least one `await` or asynchronous call within its body is prohibited.
- [ ] Code must not launch Promises without catching the error in a handleable context.

## Allowed Exceptions

- **Event Emitters/Listeners**: Code that integrates with internal *Event Loops* or Observer patterns, where error handling is delegated to the central *listener*.

## How to Detect

### Manual

Search for function calls that return Promises without `await` or `.catch()` immediately after.

### Automatic

ESLint: `no-floating-promises`, `require-await`.

## Related To

- [027 - Error Handling Quality](027_qualidade-tratamento-erros-dominio.md): reinforces
- [014 - Dependency Inversion Principle](014_principio-inversao-dependencia.md): complements
- [048 - Process Disposability](048_descartabilidade-processos.md): complements

---

**Created on**: 2025-10-08
**Version**: 1.0
