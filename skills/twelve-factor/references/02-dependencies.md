# Factor 02 — Dependencies

**deMGoncalves Rule:** [041 - Explicit Dependency Declaration](../../../rules/041_declaracao-explicita-dependencias.md)
**Question:** 100% of dependencies explicit in manifest (package.json)?

## What It Is

An application must declare **all** its dependencies explicitly and completely through a dependency manifest (e.g., `package.json`, `requirements.txt`). The application should **never** rely on the implicit existence of system-wide packages.

**Implicit dependencies break portability and reproducibility.**

## Compliance Criteria

- [ ] **100%** of runtime and build dependencies declared in manifest (`package.json`, `bun.lockb`)
- [ ] Zero global system dependencies (e.g., `npm install -g`, `apt-get`)
- [ ] Lockfile versioned and updated for deterministic builds

## ❌ Violation

```bash
# Untracked global installation
npm install -g typescript  # violation

# Dependency not declared in package.json
import express from 'express';  # used but not in dependencies

# package.json
{
  "dependencies": {
    "lodash": "^4.17.21"
    // express not declared ❌
  }
}
```

## ✅ Good

```bash
# All dependencies in manifest
npm install --save-exact typescript express lodash

# package.json
{
  "dependencies": {
    "express": "4.18.2",
    "lodash": "4.17.21"
  },
  "devDependencies": {
    "typescript": "5.0.4"
  }
}

# Lockfile versioned
git add package-lock.json  # or bun.lockb
```

## Codetag when violated

```typescript
// FIXME: Dependency axios not declared in package.json
import axios from 'axios';
```
