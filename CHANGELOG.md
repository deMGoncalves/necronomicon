# Changelog

Todas as mudanças notáveis neste projeto são documentadas aqui.

O formato segue [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/).

---

## [Unreleased]

### Adicionado
- Suporte a MCPs: `fetch`, `figma`, `github`, `memory`
- Command `/audit` para code review de branch, PR ou caminho src/
- Skill `colocation` com Vertical Slice Architecture (Context → Container → Component)
- Skill `software-quality` com McCall Quality Model (12 fatores)
- 8 novas skills de princípios: `object-calisthenics`, `solid`, `package-principles`, `clean-code`, `cdd`, `twelve-factor`, `anti-patterns`, `react`

---

## [1.0.0] — 2026-04-01

### Adicionado

**Agentes (5)**
- `@leader` — Tech Lead que classifica Quick/Task/Feature e orquestra o workflow
- `@architect` — Solution Architect com Research completo e Specs Light
- `@developer` — Developer com Vertical Slice Architecture
- `@tester` — QA Engineer com `bun test --coverage` (≥85% domain)
- `@reviewer` — Code Reviewer com CDD/ICP + 70 rules + segurança

**Rules (70)**
- Object Calisthenics 001–009 (Jeff Bay)
- SOLID 010–014 (Uncle Bob)
- Package Principles 015–020 (Robert C. Martin)
- Clean Code 021–039
- Twelve-Factor 040–051
- Anti-Patterns 052–070 (Fowler + Brown)

**Skills (27 iniciais)**
- Estrutura de classe: anatomy, constructor, bracket
- Membros: getter, setter, method
- Comportamento: event, dataflow, render, state
- Dados: enum, token, alphabetical
- Organização: colocation, revelation, story
- Composição: mixin, complexity
- Performance: big-o
- Anotação: codetags
- Design Patterns: gof (23 patterns), poeaa (51 patterns)
- Documentação: arc42, c4model, adr, bdd

**Commands (5)**
- `/start` — Inicializa feature com templates
- `/status` — Dashboard de progresso
- `/docs` — Sincroniza documentação arquitetural
- `/ship` — Commit Conventional Commits + push
- `/sync` — Atualiza branch com remoto

**Hooks (3)**
- `lint.sh` — Auto-format com Biome no PostToolUse
- `loop.sh` — Guarda workflow com tasks.md no Stop
- `prompt.sh` — Roteamento Quick/Task/Feature no UserPromptSubmit

**MCPs (4 iniciais)**
- cloudflare, context7, puppeteer, storybook

---

[Unreleased]: https://github.com/deMGoncalves/oh-my-claude/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/deMGoncalves/oh-my-claude/releases/tag/v1.0.0
