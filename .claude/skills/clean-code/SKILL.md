---
name: clean-code
description: "Práticas de Clean Code (Uncle Bob) para código limpo e manutenível. Use quando @developer aplicar as rules 021-039, ou @reviewer verificar qualidade de código além das métricas objetivas."
model: haiku
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Clean Code

Referência de práticas de Clean Code baseadas em Robert C. Martin (*Clean Code: A Handbook of Agile Software Craftsmanship*, 2008) para aplicar as rules 021–039.

---

## Quando Usar

| Agent | Contexto |
|-------|----------|
| @developer | Ao implementar rules 021–039 durante coding |
| @reviewer | Ao verificar qualidade além de métricas ICP objetivas |
| @architect | Ao avaliar decisões de design que impactam manutenibilidade |

---

## Estrutura de Referências

| Tema | Rules | Pergunta Chave | Arquivo |
|------|-------|----------------|---------|
| **Nomenclatura** | 006, 034, 035 | Os nomes revelam intenção sem comentários? | `references/naming.md` |
| **Funções** | 033, 037 | Funções fazem uma coisa só com ≤3 params? | `references/functions.md` |
| **Tratamento de Erros** | 027, 028 | Exceções de domínio em vez de null/códigos? | `references/error-handling.md` |
| **Estrutura de Código** | 021, 022, 023, 026 | Simples, DRY, sem especulação, autodocumentado? | `references/code-structure.md` |
| **Imutabilidade** | 029, 036, 038 | Objetos imutáveis, sem side effects, CQS? | `references/immutability.md` |
| **Segurança** | 030, 031, 042 | Sem eval, path aliases, secrets em env? | `references/security.md` |
| **Testes** | 032 | Cobertura ≥85% domain, AAA pattern? | `references/testing.md` |
| **Refatoração** | 039 | Código melhor do que foi encontrado? | `references/boy-scout-rule.md` |

---

## Quick Smell Detector

| Vejo no código | Regra violada | Ação imediata |
|----------------|---------------|---------------|
| `if (accountList instanceof Set)` | 035 - Nomes enganosos | Renomear para `accountSet` |
| `function process(data, shouldLog)` | 037 - Flag arguments | Extrair `processAndLog()` e `process()` |
| `return null;` em service | 027 - Error handling | Lançar `UserNotFoundError` |
| `eval(userInput)` | 030 - Unsafe functions | Usar mapa de funções seguras |
| `../../../utils/helper` | 031 - Relative imports | Usar `@utils/helper` |
| `const strName = 'John'` | 035 - Hungarian notation | Remover prefixo `str` |
| Função com 6 parâmetros | 033 - Long parameter list | Criar Parameter Object (DTO) |
| `try { } catch (e) { }` | 027 - Swallowed exception | Relançar ou tratar corretamente |
| Classe com 80 linhas | 007 - Max lines | Extrair responsabilidades |
| `API_KEY = 'sk-123'` hardcoded | 042 - Hardcoded secrets | Mover para `process.env.API_KEY` |

---

## Proibições (sempre rejeitar)

### Nomenclatura
- ❌ Nomes abreviados (ex: `usr`, `calc`, `mngr`)
- ❌ Notação húngara (ex: `strName`, `bIsActive`)
- ❌ Nomes enganosos (ex: `accountList` para Set)
- ❌ Nomes de métodos como substantivos (ex: `user()` vs `getUser()`)

### Estrutura
- ❌ Código duplicado (copy-paste >5 linhas)
- ❌ Constantes mágicas (números/strings inline sem nome)
- ❌ Funcionalidades especulativas ("para o futuro")
- ❌ Comentários redundantes (descrevem O QUÊ em vez de PORQUÊ)

### Funções
- ❌ Mais de 3 parâmetros (criar DTO)
- ❌ Boolean flags em assinatura
- ❌ Métodos híbridos Query+Command

### Segurança
- ❌ `eval()` ou `new Function()`
- ❌ Imports relativos com `../`
- ❌ Segredos hardcoded no código

### Erros
- ❌ `return null` para falhas de negócio
- ❌ `catch` vazio ou que apenas loga
- ❌ Promises não tratadas

---

## Fundamentação

| Rule | Título | Severidade | Quick Ref |
|------|--------|------------|-----------|
| 021 | Proibição de Duplicação (DRY) | 🔴 | `references/code-structure.md` |
| 022 | Simplicidade e Clareza (KISS) | 🟠 | `references/code-structure.md` |
| 023 | Sem Funcionalidade Especulativa (YAGNI) | 🟡 | `references/code-structure.md` |
| 024 | Sem Constantes Mágicas | 🔴 | `references/code-structure.md` |
| 026 | Comentários: Porquê, não O Quê | 🟡 | `references/code-structure.md` |
| 027 | Exceções de Domínio | 🟠 | `references/error-handling.md` |
| 028 | Tratamento de Promises | 🔴 | `references/error-handling.md` |
| 029 | Imutabilidade (Object.freeze) | 🟠 | `references/immutability.md` |
| 030 | Sem Funções Inseguras | 🔴 | `references/security.md` |
| 031 | Sem Imports Relativos | 🔴 | `references/security.md` |
| 032 | Cobertura de Testes ≥85% | 🔴 | `references/testing.md` |
| 033 | Máx 3 Parâmetros | 🟠 | `references/functions.md` |
| 034 | Nomes Consistentes | 🟠 | `references/naming.md` |
| 035 | Sem Nomes Enganosos | 🔴 | `references/naming.md` |
| 036 | Sem Side Effects | 🔴 | `references/immutability.md` |
| 037 | Sem Flag Arguments | 🟠 | `references/functions.md` |
| 038 | Separação Command-Query (CQS) | 🟠 | `references/immutability.md` |
| 039 | Regra do Escoteiro | 🟡 | `references/boy-scout-rule.md` |
| 042 | Secrets em Ambiente | 🔴 | `references/security.md` |

---

## Workflow de Aplicação

```
1. Leia referência relevante (ex: functions.md para rule 033)
2. Identifique violações usando Quick Smell Detector
3. Aplique correção conforme exemplos da referência
4. Valide conformidade (sem smell detectável)
```

**Skills relacionadas:**
- [`object-calisthenics`](../object-calisthenics/SKILL.md) — reforça: OC são exercícios práticos de Clean Code
- [`solid`](../solid/SKILL.md) — reforça: SOLID é fundamento teórico do Clean Code
- [`anti-patterns`](../anti-patterns/SKILL.md) — complementa: anti-patterns são as violações do Clean Code

---

**Criada em**: 2026-04-01
**Versão**: 1.0.0
