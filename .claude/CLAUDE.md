# Necronomicon — Claude Code Config

## Propósito

Vault de configuração do Claude Code. Regras em `.claude/rules/` + skills em `.claude/skills/` + agents em `.claude/agents/` formam o ecossistema **Spec Flow** para desenvolvimento assistido por IA.

## Spec Flow: Research → Spec → Code → Docs

| Fase | Agente | Entrada | Artefatos produzidos |
|------|--------|---------|----------------------|
| 1. Research | 🟢 @architect | Feature request | `changes/00X/PRD.md`, `changes/00X/design.md` |
| 2. Spec | 🟢 @architect | PRD + design | `changes/00X/specs.md`, `changes/00X/tasks.md` |
| 3. Code | 🟡 @developer → 🔴 @tester → 🟣 @reviewer | specs.md | Código em `src/` |
| 4. Docs | 🟢 @architect | Código implementado | `docs/arc42/`, `docs/c4/`, `docs/adr/`, `docs/bdd/` |

**🔵 @leader orquestra todas as fases.** Recebe o prompt, entende o escopo (fluxo completo ou parcial), delega e coordena. O workflow não é rígido — @leader adapta conforme o pedido do usuário.

## Agentes

| Cor | Agent | Papel | Modelo |
|-----|-------|-------|--------|
| 🔵 | @leader | Tech Lead — orquestra Spec Flow, gerencia `tasks.md`, coordena loops de feedback | opus |
| 🟢 | @architect | Solution Architect — cria PRD/design/specs, escreve `docs/` (Arc42, C4, ADR, BDD), aplica GoF + PoEAA | opus |
| 🟡 | @developer | Developer JS/TS — implementa `specs.md`, aplica 70 rules + 26 skills | sonnet |
| 🔴 | @tester | QA Engineer — testa, valida cobertura ≥85% domain, retorna para @developer se falhar | sonnet |
| 🟣 | @reviewer | Code Reviewer — CDD/ICP, anota violações via codetags, retorna para @developer se rejeitar | opus |

## Loop de Feedback (Fase 3: Code)

```
@leader → @developer → @tester ──(falhou)──→ @developer
                           │
                        (passou)
                           ↓
                       @reviewer ──(rejeitado)──→ @developer → @tester
                           │
                       (aprovado)
                           ↓
                        @leader → Fase 4: Docs
```

## Estrutura de Arquivos

```
.claude/
├── CLAUDE.md          ← hub central (este arquivo)
├── agents/            ← leader, architect, developer, tester, reviewer
├── skills/            ← 26 skills (code + arch/docs)
├── rules/             ← 70 regras (001–070)
├── hooks/             ← lint.sh, loop.sh, prompt.sh
└── settings.json      ← hooks + permissions

changes/
└── 00X_feature-name/
    ├── PRD.md         ← objetivos, requisitos, regras de negócio
    ├── design.md      ← decisões técnicas, patterns, arquitetura
    ├── specs.md       ← interfaces, schemas, exemplos de código
    └── tasks.md       ← tarefas T-001…T-NNN com critérios de aceite

docs/
├── arc42/             ← 12 seções arquiteturais (§1–§12)
├── c4/                ← 4 níveis: Context → Container → Component → Code
├── adr/               ← Architecture Decision Records (ADR-NNN)
└── bdd/               ← Features Gherkin em pt-BR (.feature)
```

## Skills (26 total)

| Grupo | Skills |
|-------|--------|
| Estrutura de classe | anatomy, constructor, bracket |
| Membros | getter, setter, method |
| Comportamento | event, dataflow, render, state |
| Dados | enum, token, alphabetical |
| Organização | colocation, revelation, story |
| Composição | mixin, complexity |
| Performance | big-o |
| Anotação | codetags |
| Design Patterns | **gof**, **poeaa** |
| Documentação Arquitetural | **arc42**, **c4model**, **adr**, **bdd** |

## Regras (70 total)

| Categoria | IDs | Fonte |
|-----------|-----|-------|
| Object Calisthenics | 001–009 | Object Calisthenics (Jeff Bay) |
| SOLID | 010–014 | Clean Architecture (Uncle Bob) |
| Package Principles | 015–020 | Clean Architecture (Uncle Bob) |
| Clean Code | 021–039 | Clean Code + práticas gerais |
| Twelve-Factor | 040–051 | The Twelve-Factor App |
| Anti-Patterns | 052–070 | Refactoring (Fowler) + AntiPatterns (Brown) |

Próximo ID disponível: `071` · Referências cruzadas bidirecionais obrigatórias.
Tipos de relação: `reforça` · `complementa` · `substitui` · `depende`
Severidade: 🔴 bloqueia PR · 🟠 exige justificativa · 🟡 melhoria esperada

## Hooks Ativos

| Evento | Hook | Trigger | Comportamento |
|--------|------|---------|---------------|
| `PostToolUse` | `lint.sh` | `Write\|Edit\|NotebookEdit` | `biome check --write` em .ts/.tsx/.js/.jsx/.json |
| `Stop` | `loop.sh` | Fim de cada resposta | Verifica `tasks.md`; bloqueia se há `- [ ]` pendentes |
| `UserPromptSubmit` | `prompt.sh` | Todo prompt do usuário | Injeta contexto para routing ao @leader em tarefas de dev |

## Formato Obrigatório de Regras

```markdown
# [Título da Regra]
**ID**: [CATEGORIA-NNN ou AP-NN-NNN]
**Severidade**: [🔴 Crítica | 🟠 Alta | 🟡 Média]
**Categoria**: [Estrutural | Comportamental | Criacional | Infraestrutura]
---
## O que é
## Por que importa
## Critérios Objetivos   ← checkboxes [ ]
## Exceções Permitidas
## Como Detectar        ← subseções Manual e Automático
## Relacionada com      ← links com tipo de relação
---
**Criada em**: AAAA-MM-DD  **Versão**: 1.0
```
