# Mapping @reviewer → Codetags

## Violation Severity → Tag

| Severity | Tag to use | Blocks PR? |
|----------|------------|------------|
| 🔴 Critical (rules 001-003, 007, 010...) | `FIXME` | Yes |
| 🟠 High (rules 004-006, 011-020...) | `TODO` | No — should fix |
| 🟡 Medium (rules 023, 026, 039...) | `XXX` | No — improvement expected |
| 🔐 Critical security (CWE Injection, Auth) | `FIXME` | Yes |
| 🔐 High security (CWE Crypto, SSRF) | `TODO` | No |
| 🔐 Medium security (CWE Exposure) | `XXX` | No |
| ⚡ Performance (ICP, Big-O) | `OPTIMIZE` | No |
| ❓ Non-obvious decision | `NOTE` | No |
| 🔄 Needs verification | `REVIEW` | No |

## @reviewer Flow

```
@reviewer analyzes file
    ↓
Violation found → selects tag per table above
    ↓
Inserts on line ABOVE violated section:
// TAG: violation description — suggested correction
    ↓
Reports verdict: Approved / Attention / Rejected
```
