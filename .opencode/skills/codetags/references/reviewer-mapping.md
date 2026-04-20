# Mapeamento @reviewer → Codetags

## Severidade de Violação → Tag

| Severidade | Tag a usar | Bloqueia PR? |
|------------|------------|--------------|
| 🔴 Crítica (rules 001-003, 007, 010...) | `FIXME` | Sim |
| 🟠 Alta (rules 004-006, 011-020...) | `TODO` | Não — deve corrigir |
| 🟡 Média (rules 023, 026, 039...) | `XXX` | Não — melhoria esperada |
| 🔐 Segurança crítica (CWE Injection, Auth) | `FIXME` | Sim |
| 🔐 Segurança alta (CWE Crypto, SSRF) | `TODO` | Não |
| 🔐 Segurança média (CWE Exposição) | `XXX` | Não |
| ⚡ Performance (ICP, Big-O) | `OPTIMIZE` | Não |
| ❓ Decisão não óbvia | `NOTE` | Não |
| 🔄 Precisa verificação | `REVIEW` | Não |

## Fluxo do @reviewer

```
@reviewer analisa arquivo
    ↓
Violação encontrada → seleciona tag conforme tabela acima
    ↓
Insere na linha ACIMA do trecho violado:
// TAG: descrição da violação — correção sugerida
    ↓
Reporta veredito: Aprovado / Atenção / Rejeitado
```
