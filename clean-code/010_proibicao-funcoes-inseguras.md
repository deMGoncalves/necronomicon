# Prohibition of Unsafe Functions (eval, new Function, Secrets)

**ID**: BEHAVIORAL-030
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What it is

Prohibits the use of functions that execute arbitrary code from strings (e.g., `eval()`) or that create severe security vulnerabilities, such as *hardcoding* secrets.

## Why it matters

Functions like `eval()` are attack vectors for **Remote Code Execution (RCE)** and code injection. *Hardcoding* secrets violates security policy, making *deployment* insecure.

## Objective Criteria

- [ ] The use of `eval()` and `new Function()` (without the purpose of isolated compilation) is prohibited.
- [ ] API keys or secrets must be injected exclusively via `process.env` or secret management tool.
- [ ] Concatenating user input *strings* into direct queries to the file system or *shell* commands is prohibited.

## Allowed Exceptions

- **Tooling/Build Steps**: Controlled use of *eval* or *new Function* in *build scripts* to optimize *bundling*.

## How to Detect

### Manual

Search for `eval`, `new Function`, or *hardcoded* API keys.

### Automatic

ESLint: `no-eval`, `no-implied-eval`.

## Related to

- [024 - Prohibition of Magic Constants](004_proibicao-constantes-magicas.md): complements
- [042 - Configurations via Environment](../twelve-factor/003_configuracoes-via-ambiente.md): reinforces

---

**Created on**: 2025-10-08
**Version**: 1.0
