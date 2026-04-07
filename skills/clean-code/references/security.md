# Security (Rules 030, 031, 042)

## Rules

- **030**: Prohibition of `eval()`, `new Function()` and hardcoded secrets
- **031**: Prohibition of relative imports (require path aliases)
- **042**: Secrets via environment variables

## Checklist

- [ ] No `eval()` or `new Function()` (except isolated build tooling)
- [ ] No user input concatenation in queries/shell commands
- [ ] No imports with `../` (use path aliases like `@utils/`)
- [ ] API keys via `process.env` or secret manager
- [ ] No secrets in code or versioned

## Examples

```typescript
// ❌ Violations
// eval (030)
function calculate(expression) {
  return eval(expression); // RCE if expression from user
}

// Hardcoded secret (030, 042)
const client = new ApiClient({ apiKey: 'sk-prod-abc123xyz' });

// Relative import (031)
import { helper } from '../../../utils/helper'; // breakable

// ✅ Compliance
// No eval
function calculate(a: number, operator: string, b: number) {
  const ops = {
    '+': (x, y) => x + y,
    '-': (x, y) => x - y,
    '*': (x, y) => x * y,
    '/': (x, y) => x / y
  };
  return ops[operator]?.(a, b) ?? null;
}

// Secrets via env
const client = new ApiClient({
  apiKey: process.env.API_KEY // injected via .env
});

// Path alias
import { helper } from '@utils/helper';

// tsconfig.json or vite.config.js
{
  "compilerOptions": {
    "paths": {
      "@utils/*": ["./src/utils/*"]
    }
  }
}
```

## Relation to ICP

- `eval` creates dynamic coupling impossible to analyze statically
- Path aliases facilitate refactorings (imports don't break when moving files)
