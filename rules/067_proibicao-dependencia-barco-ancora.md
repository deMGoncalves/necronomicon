# Prohibition of Boat Anchor Dependency

**ID**: AP-01-067
**Severity**: 🟡 Medium
**Category**: Structural

---

## What It Is

Boat Anchor occurs when a dependency, library, or component is imported into the codebase, installed in `package.json` or `requirements.txt`, but is never used or only used superficially. Like a boat anchor that interferes with movement, these unused dependencies add complexity and maintenance cost without bringing value. Variant of Lava Flow for dependencies.

## Why It Matters

- Dependency bloat: more files, more downloads, more build/CI/CD time
- Security vulnerabilities: unused dependencies aren't monitored but may have CVEs
- Onboarding difficulty: developers wonder "what is X for?" and waste time researching
- Technology confusion: appears to be used but isn't; false impression of capabilities
- Complex licenses: unused dependencies can introduce licensing issues without reason

## Objective Criteria

- [ ] Dependency listed in `package.json`, `requirements.txt`, `Pipfile`, `go.mod`, but never imported
- [ ] Library imported but never called (`import X` without `X.method()` usage)
- [ ] Dead dependency (unmaintained) kept "just in case" without future usage timeline
- [ ] Framework/library installed but only 1-2 features used when simple alternative exists

## Allowed Exceptions

- DevDependencies used in build-tooling only (linters, formatters not referenced in prod code)
- Optional dependencies where usage is runtime unknown until execution (plugins)
- Future dependency with well-defined roadmap (e.g., feature requiring X in Q3) if documented in comments/tickets

## How to Detect

### Manual
- Compare `package.json`/`requirements.txt` with `grep -r "^import\|^from"` or `grep -r "^require\|^use"` — diff is boat anchors
- Look for libraries where docs/wiki mention "we use X" but grep code base shows zero usage
- Check tests: if library doesn't appear in tests only in production code not imported, it's boat anchor

### Automatic
- Tools: npm-check, depcheck, pipreqs, go mod tidy
- CI/CD: scripts that detect unused dependencies and fail build
- Dependency analysis tools: detect imports vs usage across entire codebase

## Related To

- [056 - Prohibition of Zombie Code (Lava Flow)](056_proibicao-codigo-zombie-lava-flow.md): complements
- [041 - Explicit Dependency Declaration](041_declaracao-explicita-dependencias.md): reinforces
- [039 - Boy Scout Rule (Continuous Refactoring)](039_regra-escoteiro-refatoracao-continua.md): reinforces
- [043 - Environment Configurations](043_configuracoes-via-ambiente.md): complements
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): reinforces

---

**Created on**: 2026-03-28
**Version**: 1.0
