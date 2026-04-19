---
name: clean-code
description: "Práticas Clean Code (Uncle Bob) para código limpo e manutenível. Use quando @coder aplica regras 021-039, ou @architect verifica qualidade de código além de métricas objetivas."
model: haiku
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Clean Code

Referência de práticas Clean Code baseadas em Robert C. Martin (*Clean Code: A Handbook of Agile Software Craftsmanship*, 2008) para aplicar regras 021–039.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Qualquer implementação em `src/` por @coder; revisão de qualidade por @architect |
| **Prerequisites** | Regras 021–042 carregadas; entendimento básico de OOP |
| **Constraints** | Não aplica a arquivos de configuração, DTOs puros ou código legado em isolamento |
| **Scope** | Nomenclatura, estrutura de funções, tratamento de erros, imutabilidade, segurança, testes |

---

## Quando Usar

| Agente | Contexto |
|-------|---------|
| @coder | Ao implementar regras 021–039 durante codificação |
| @architect | Ao verificar qualidade além de métricas objetivas ICP |
| @architect | Ao avaliar decisões de design que impactam manutenibilidade |

---

## Estrutura de Referência

| Tema | Regras | Pergunta-Chave | Arquivo |
|-------|-------|--------------|------|
| **Nomenclatura** | 006, 034, 035 | Nomes revelam intenção sem comentários? | `references/naming.md` |
| **Funções** | 033, 037 | Funções fazem uma coisa com ≤3 params? | `references/functions.md` |
| **Tratamento de Erros** | 027, 028 | Exceções de domínio ao invés de null/códigos? | `references/error-handling.md` |
| **Estrutura de Código** | 021, 022, 023, 026 | Simples, DRY, sem especulação, auto-documentado? | `references/code-structure.md` |
| **Imutabilidade** | 029, 036, 038 | Objetos imutáveis, sem efeitos colaterais, CQS? | `references/immutability.md` |
| **Segurança** | 030, 031, 042 | Sem eval, path aliases, secrets em env? | `references/security.md` |
| **Testes** | 032 | Cobertura ≥85% domínio, padrão AAA? | `references/testing.md` |
| **Refatoração** | 039 | Código melhor do que encontrado? | `references/boy-scout-rule.md` |

---

## Detector Rápido de Smell

| Vejo no código | Regra violada | Ação imediata |
|---------------|---------------|------------------|
| `if (accountList instanceof Set)` | 035 - Nomes enganosos | Renomear para `accountSet` |
| `function process(data, shouldLog)` | 037 - Argumentos sinalizadores | Extrair `processAndLog()` e `process()` |
| `return null;` em service | 027 - Tratamento de erros | Lançar `UserNotFoundError` |
| `eval(userInput)` | 030 - Funções inseguras | Usar mapa de função seguro |
| `../../../utils/helper` | 031 - Imports relativos | Usar `@utils/helper` |
| `const strName = 'John'` | 035 - Notação húngara | Remover prefixo `str` |
| Função com 6 parâmetros | 033 - Lista longa de parâmetros | Criar Parameter Object (DTO) |
| `try { } catch (e) { }` | 027 - Exceção engolida | Relançar ou tratar corretamente |
| Classe com 80 linhas | 007 - Máx linhas | Extrair responsabilidades |
| `API_KEY = 'sk-123'` hardcoded | 042 - Secrets hardcoded | Mover para `process.env.API_KEY` |

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
- ❌ Funcionalidade especulativa ("para o futuro")
- ❌ Comentários redundantes (descrevem O QUE ao invés de POR QUÊ)

### Funções
- ❌ Mais de 3 parâmetros (criar DTO)
- ❌ Flags booleanos na assinatura
- ❌ Métodos híbridos Query+Command

### Segurança
- ❌ `eval()` ou `new Function()`
- ❌ Imports relativos com `../`
- ❌ Secrets hardcoded no código

### Erros
- ❌ `return null` para falhas de negócio
- ❌ `catch` vazio ou apenas loga
- ❌ Promises não tratadas

---

## Justificativa

| Regra | Título | Severidade | Ref Rápida |
|------|-------|----------|-----------|
| 021 | Proibição de Duplicação (DRY) | 🔴 | `references/code-structure.md` |
| 022 | Simplicidade e Clareza (KISS) | 🟠 | `references/code-structure.md` |
| 023 | Sem Funcionalidade Especulativa (YAGNI) | 🟡 | `references/code-structure.md` |
| 024 | Sem Constantes Mágicas | 🔴 | `references/code-structure.md` |
| 026 | Comentários: Por Quê, não O Quê | 🟡 | `references/code-structure.md` |
| 027 | Exceções de Domínio | 🟠 | `references/error-handling.md` |
| 028 | Tratamento de Promise | 🔴 | `references/error-handling.md` |
| 029 | Imutabilidade (Object.freeze) | 🟠 | `references/immutability.md` |
| 030 | Sem Funções Inseguras | 🔴 | `references/security.md` |
| 031 | Sem Imports Relativos | 🔴 | `references/security.md` |
| 032 | Cobertura de Teste ≥85% | 🔴 | `references/testing.md` |
| 033 | Máx 3 Parâmetros | 🟠 | `references/functions.md` |
| 034 | Nomes Consistentes | 🟠 | `references/naming.md` |
| 035 | Sem Nomes Enganosos | 🔴 | `references/naming.md` |
| 036 | Sem Efeitos Colaterais | 🔴 | `references/immutability.md` |
| 037 | Sem Argumentos Sinalizadores | 🟠 | `references/functions.md` |
| 038 | Separação Command-Query (CQS) | 🟠 | `references/immutability.md` |
| 039 | Regra do Escoteiro | 🟡 | `references/boy-scout-rule.md` |
| 042 | Secrets no Ambiente | 🔴 | `references/security.md` |

---

## Workflow de Aplicação

```
1. Ler referência relevante (ex: functions.md para regra 033)
2. Identificar violações usando Detector Rápido de Smell
3. Aplicar correção segundo exemplos da referência
4. Validar conformidade (nenhum smell detectável)
```

**Skills relacionadas:**
- [`object-calisthenics`](../object-calisthenics/SKILL.md) — reforça: OC são exercícios práticos de Clean Code
- [`solid`](../solid/SKILL.md) — reforça: SOLID é fundação teórica do Clean Code
- [`anti-patterns`](../anti-patterns/SKILL.md) — complementa: anti-patterns são violações do Clean Code

---

**Criada em**: 2026-04-01
**Versão**: 1.0.0
