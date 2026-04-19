# Changelog

Todas as mudanças relevantes deste projeto estão documentadas aqui.

O formato segue [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

_Nenhuma mudança pendente de release._

---

## [2.0.0] — 2026-04-19

### Breaking Changes
- Agents removidos: `@leader`, `@developer`, `@reviewer`
- Contador de tentativas renomeado: `attempts-developer` → `attempts-coder`
- Contador `attempts-reviewer` removido do `tasks.md`

### Added

**Agents (sistema com 6 agents)**
- `@planner` (Claude Opus) — Planejamento estratégico, decomposição de tasks, gestão de contexto em `changes/`
- `@designer` (Claude Sonnet) — Specs de componentes UI/UX, design tokens, acessibilidade (WCAG)
- `@deepdive` (Claude Opus) — Investigação profunda: bugs, performance, segurança, pesquisa tecnológica
- `@coder` substitui `@developer` — Mesmo papel de implementação, design agnóstico de tecnologia
- `@tester` — Aprimorado com padrão evaluator-optimizer (veredicto binário: passa/falha)
- `@architect` — Aprimorado com modo de revisão arquitetural (absorve responsabilidades do `@reviewer`)

**Modos de Workflow (5)**
- Modo `Research`: causa raiz desconhecida → `@deepdive` investiga antes do planejamento
- Modo `UI`: trabalho com componentes → `@designer` + `@architect` em paralelo antes do `@coder`

**Documentação**
- Toda a documentação interna de `.claude/` traduzida para português brasileiro
- Todos os arquivos de agent tornados agnósticos de tecnologia (sem nomes de ferramentas específicas)
- Artefato `design-spec.md` adicionado ao contexto de `changes/` (modo UI)
- Artefato `findings.md` adicionado ao contexto de `changes/` (modo Research)

### Changed
- `@architect` agora gerencia revisão arquitetural (ICP/CDD + 70 regras) no modo de revisão
- Hook `prompt.sh` atualizado para detectar e sugerir 5 modos de workflow (eram 3)
- `commands/audit.md` redireciona para `@architect` em vez do `@reviewer` removido
- Template de `commands/start.md` atualizado com novos nomes de agents e contadores
- `GRAPH.md` atualizado para refletir a estrutura de dependências com 6 agents

### Removed
- Agent `@leader` (responsabilidades absorvidas pelo papel de Tech Lead em CLAUDE.md + `@planner`)
- Agent `@developer` (renomeado para `@coder`)
- Agent `@reviewer` (responsabilidades absorvidas pelo modo de revisão do `@architect`)

---

## [1.0.0] — 2026-04-01

### Added

**Agents (5)**
- `@leader` — Tech Lead que classifica Quick/Task/Feature e orquestra o workflow
- `@architect` — Arquiteto de Soluções com Research completo e Light Specs
- `@developer` — Desenvolvedor com Arquitetura de Vertical Slice
- `@tester` — Engenheiro de QA com `bun test --coverage` (≥85% no domínio)
- `@reviewer` — Revisor de Código com CDD/ICP + 70 regras + segurança

**Regras (70)**
- Object Calisthenics 001–009 (Jeff Bay)
- SOLID 010–014 (Uncle Bob)
- Princípios de Pacotes 015–020 (Robert C. Martin)
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
- Padrões de Design: gof (23 padrões), poeaa (51 padrões)
- Documentação: arc42, c4model, adr, bdd

**Comandos (5)**
- `/start` — Inicializa feature com templates
- `/status` — Painel de progresso
- `/docs` — Sincroniza documentação arquitetural
- `/ship` — Commit com Conventional Commits + push
- `/sync` — Atualiza branch com o remoto

**Hooks (3)**
- `lint.sh` — Auto-formata com Biome no PostToolUse
- `loop.sh` — Protege o workflow com tasks.md no Stop
- `prompt.sh` — Roteamento Quick/Task/Feature no UserPromptSubmit

**MCPs (4 iniciais)**
- cloudflare, context7, puppeteer, storybook

---

[Unreleased]: https://github.com/deMGoncalves/oh-my-claude/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/deMGoncalves/oh-my-claude/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/deMGoncalves/oh-my-claude/releases/tag/v1.0.0
