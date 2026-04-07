# Prohibition of Unsafe Functions (eval, new Function, Secrets)

**ID**: COMPORTAMENTAL-030
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What It Is

Prohibits using functions that execute arbitrary code from strings (e.g., `eval()`) or that create severe security vulnerabilities, such as *hardcoding* secrets.

## Why It Matters

Functions like `eval()` are attack vectors for **Remote Code Execution (RCE)** and code injection. *Hardcoding* secrets violates security policy, making *deployment* insecure.

## Objective Criteria

- [ ] Using `eval()` and `new Function()` functions (without the purpose of isolated compilation) is prohibited.
- [ ] API keys or secrets must be injected exclusively via `process.env` or secret management tool.
- [ ] Concatenation of user input *strings* in direct queries to the filesystem or *shell* commands is prohibited.

## Allowed Exceptions

- **Tooling/Build Steps**: Controlled use of *eval* or *new Function* in *build scripts* to optimize *bundling*.

## How to Detect

### Manual

Search for `eval`, `new Function`, or *hardcoded* API keys.

### Automatic

ESLint: `no-eval`, `no-implied-eval`.

## Related To

- [024 - Prohibition of Magic Constants](024_proibicao-constantes-magicas.md): complements
- [042 - Configuration via Environment](042_configuracoes-via-ambiente.md): reinforces

---

**Created on**: 2025-10-08
**Version**: 1.0
