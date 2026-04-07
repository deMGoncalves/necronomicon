# Boat Anchor

**Severity:** 🟡 Medium
**Associated Rule:** Rule 067

## What It Is

Software component (library, module, class, entire system) or dependency kept in codebase because "it might be useful in the future," but currently has no active purpose. Like an anchor on a boat: weight without utility.

## Symptoms

- Dependency listed in `package.json`, `requirements.txt` but never imported
- Library imported but never called (`import X` without `X.method()` usage)
- Imported modules but never used
- Dependencies in `package.json` without any code reference
- Provisioned infrastructure that nobody uses (queues, databases, services)
- "Future integration" code written before integration exists
- Comments like `// will be used when we implement X`

## ❌ Example (violation)

```javascript
// ❌ Dependency installed "for when we need it"
// package.json has: "pdfkit", "sharp", "node-cron"
// None of them have a single line of use in the code

// ❌ Module created "for next sprint"
export class ReportExporter {
  exportToExcel() { /* TODO: implement */ }
  exportToPowerPoint() { /* TODO: implement */ }
}
```

## ✅ Refactoring

```javascript
// ✅ Only what is used exists (YAGNI)
// package.json: only dependencies with real references in code
// Module created when feature is needed, with tests from the start

// Use: npm-check, depcheck, pipreqs, go mod tidy to detect
```

## Suggested Codetag

```typescript
// FIXME: Boat Anchor — pdfkit/sharp/node-cron installed but never referenced
// TODO: npm uninstall; create module when need is real
```
