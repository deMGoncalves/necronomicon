# oh my claude

**Autor:** Cleber de Moraes Goncalves · [@deMGoncalves](https://github.com/deMGoncalves)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-CLI-blueviolet)](https://code.claude.com)
[![Agents](https://img.shields.io/badge/Agents-5-blue)](#agents)
[![Skills](https://img.shields.io/badge/Skills-35-green)](#skills-35-skills)
[![Rules](https://img.shields.io/badge/Rules-70-orange)](#rules-70-regras)
[![MCPs](https://img.shields.io/badge/MCPs-8-lightgrey)](#mcps)

Workflow pessoal de desenvolvimento assistido por IA. Não é um framework, não é uma ferramenta — é a forma como eu penso, escrevo e construo software, codificada em agentes, regras e skills para o [Claude Code](https://code.claude.com).

---

## Setup

### Pré-requisitos

| Ferramenta                                 | Para que serve                     | Instalação                                  |
| ------------------------------------------ | ---------------------------------- | ------------------------------------------- |
| [Claude Code CLI](https://code.claude.com) | Executar os agentes e o workflow   | `npm install -g @anthropic-ai/claude-code`  |
| [Bun](https://bun.sh)                      | Runtime + test runner              | `curl -fsSL https://bun.sh/install \| bash` |
| [Biome](https://biomejs.dev)               | Linter + formatter (auto via hook) | já incluso — roda via `bunx biome`          |
| [GitHub CLI](https://cli.github.com)       | Usado pelo `/audit` e `/ship`      | `brew install gh`                           |
| [jq](https://jqlang.github.io/jq/)         | Parsing JSON nos hooks             | `brew install jq`                           |

### Configurar

```bash
# 1. Clone o repositório
git clone https://github.com/deMGoncalves/necronomicon
cd necronomicon

# 2. Abrir no Claude Code
claude .
```

O Claude Code detecta automaticamente o `.claude/` e carrega todos os agentes, skills, rules e hooks.

### Tokens necessários (MCPs opcionais)

Dois MCPs precisam de tokens para funcionar — edite `.mcp.json` com os valores reais:

```bash
# Token do Figma
# figma.com → Settings → Security → Personal access tokens
FIGMA_TOKEN="seu-token-aqui"

# Token do GitHub
# github.com → Settings → Developer settings → Personal access tokens → Classic
# Scopes necessários: repo, workflow
GITHUB_TOKEN="ghp_seu-token-aqui"
```

Substitua os placeholders em `.mcp.json`:

- `SEU_FIGMA_TOKEN_AQUI` → token do Figma
- `SEU_GITHUB_TOKEN_AQUI` → token do GitHub

Os outros 6 MCPs (`cloudflare`, `context7`, `fetch`, `memory`, `puppeteer`, `storybook`) funcionam sem configuração adicional.

---

## Estrutura

```
.claude/
├── CLAUDE.md          ← hub central
├── GRAPH.md           ← mapa de dependências (Mermaid)
├── agents/            ← 5 agentes especializados
├── skills/            ← 35 skills (código + arquitetura + qualidade)
├── rules/             ← 70 regras arquiteturais (001–070)
├── commands/          ← 5 comandos de workflow
├── hooks/             ← 3 hooks automáticos
└── settings.json      ← permissões + hooks

changes/               ← contexto persistente de features
└── 00X_feature-name/
    ├── PRD.md         ← (só Feature) requisitos + regras de negócio
    ├── design.md      ← (só Feature) decisões técnicas + patterns
    ├── specs.md       ← (Task + Feature) interfaces + critérios de aceite
    └── tasks.md       ← T-001…T-NNN + counters de tentativas

docs/                  ← documentação arquitetural sincronizada
├── arc42/             ← 12 seções arquiteturais
├── c4/                ← 4 níveis de abstração
├── adr/               ← Architecture Decision Records
└── bdd/               ← features Gherkin em pt-BR
```

---

## Arquitetura

### Componentes e conexões

```
 ┌──────────────────────────────────────────────────────────────┐
 │                          .claude/                            │
 │                                                              │
 │  ┌──────────────┐  ┌────────────────┐  ┌─────────────────┐   │
 │  │   hooks/     │  │   commands/    │  │    agents/      │   │
 │  │              │  │                │  │                 │   │
 │  │ prompt.sh    │  │  /start        │  │  🔵 @leader     │   │
 │  │ ↳ modo hint  │  │  /status       │  │  🟢 @architect  │   │
 │  │              │  │  /audit        │  │  🟡 @developer  │   │
 │  │ lint.sh      │  │  /docs         │  │  🔴 @tester     │   │
 │  │ ↳ biome fmt  │  │  /ship  /sync  │  │  🟣 @reviewer   │   │
 │  │              │  │                │  │                 │   │
 │  │ loop.sh      │  └────────────────┘  └────────┬────────┘   │
 │  │ ↳ tasks.md   │                               │            │
 │  └──────┬───────┘                               │            │
 │         └───────────────────────────────────────┘            │
 │                              │ carregam                      │
 │  ┌───────────────────────────▼───────────────────────────┐   │
 │  │   skills/ (35)                    rules/ (70)         │   │
 │  │                                                       │   │
 │  │  cdd · codetags · complexity    001–009 Object Cal.   │   │
 │  │  solid · gof · poeaa            010–014 SOLID         │   │
 │  │  colocation · clean-code · ...  052–070 Anti-Patterns │   │
 │  └───────────────────────────────────────────────────────┘   │
 │                                                              │
 │  ┌───────────────────────────────────────────────────────┐   │
 │  │  .mcp.json — MCPs (8)                                 │   │
 │  │  figma · github · fetch · memory · puppeteer · ...    │   │
 │  └───────────────────────────────────────────────────────┘   │
 └──────────────────────────────────────────────────────────────┘
```

### Fluxo de uma tarefa

```
  input do usuário
       │
  ┌────▼──────────────────────────────────────────────┐
  │ prompt.sh — detecta verbo de ação → injeta modo   │
  └────┬──────────────────────────────────────────────┘
       │
  ┌────▼─────────────────────────────────────────────────┐
  │                  🔵 @leader                          │
  │         classifica → Quick / Task / Feature          │
  └────┬─────────────────────┬──────────────┬────────────┘
       │                     │              │
    Quick                  Task          Feature
       │                     │              │
       │              ┌──────▼──────┐  ┌───▼──────────────┐
       │              │ 🟢 @arch    │  │   🟢 @architect   │
       │              │ specs light │  │ PRD+design+specs │
       │              └──────┬──────┘  └───┬──────────────┘
       │                     │             │
       └─────────────────────┴─────────────┘
                             │
                  src/[context]/[container]/[component]/
                             │
  ┌──────────────────────────▼────────────────────────────┐
  │ 🟡 @developer — controller · service · model · repo   │
  └──────────────────────────┬────────────────────────────┘
                  [lint.sh → biome format em cada Write]
  ┌──────────────────────────▼────────────────────────────┐
  │ 🔴 @tester — bun test --coverage  ≥ 85% domain        │
  └──────────────────────────┬────────────────────────────┘
  ┌──────────────────────────▼────────────────────────────┐
  │ 🟣 @reviewer — ICP · 70 rules · security              │
  │               codetags educativos no código           │
  └────────────┬─────────────────────────┬────────────────┘
               │                         │
         ✅ Aprovado             ❌ Rejeitado
               │                    ↩ @developer (até 3x)
  [loop.sh verifica tasks.md · bloqueia se houver - [ ]]
```

---

## Como funciona

Todo pedido de desenvolvimento passa pelo `@leader`, que **classifica o pedido em um dos 3 modos antes de agir**:

### Modo Quick — 🟡 @developer direto

Para mudanças pontuais em ≤ 2 arquivos sem nova entidade de domínio.

```
"corrige o typo no UserController"
"remove os console.log de src/"
"ajusta timeout de 30s para 60s"
    ↓
🟡 @developer → 🔴 @tester → 🟣 @reviewer → Concluído
```

### Modo Task — specs light + Code

Para novo contrato de interface, escopo claro, sem incerteza arquitetural.

```
"adiciona endpoint POST /users/:id/roles"
"integra SendGrid no fluxo de registro"
    ↓
changes/00X/ + 🟢 @architect specs.md
    ↓
🟡 @developer → 🔴 @tester → 🟣 @reviewer → Concluído
```

### Modo Feature — Spec Flow completo

Para nova entidade de domínio, incerteza técnica, impacto arquitetural amplo.

```
"implementa autenticação OAuth2 com Google"
"cria módulo de cobrança com Stripe"
    ↓
Fase 1: 🟢 @architect Research (PRD + design + specs)
Fase 2: 🔵 @leader cria tasks.md
Fase 3: 🟡 @developer → 🔴 @tester → 🟣 @reviewer (loops ≤ 3x)
Fase 4: 🟢 @architect Docs Sync (arc42, c4, adr, bdd)
```

### Loop de feedback (Fase 3)

```
🟡 @developer → 🔴 @tester ──(falhou ≤3x)──→ 🟡 @developer
                      │
                   (passou)
                      ↓
              🟣 @reviewer ──(rejeitado ≤3x)──→ 🟡 @developer
                      │                                │
                  (aprovado)            (attempts-developer ≥ 3)
                      ↓                                ↓
              🔵 @leader finaliza          🔵 @leader → Re-Spec
             (Docs se Feature)         (🟢 @architect revisa specs.md)
```

---

## Agents

| Agent        | Modelo | Papel                                                                        |
| ------------ | ------ | ---------------------------------------------------------------------------- |
| `@leader`    | opus   | Classifica Quick/Task/Feature, orquestra fases, gerencia re-spec             |
| `@architect` | opus   | Research completo (PRD+design+specs) ou specs light — mantém docs/           |
| `@developer` | sonnet | Implementa via specs.md ou pedido direto (Quick)                             |
| `@tester`    | sonnet | Gera e executa testes — `bun test --coverage` — cobertura ≥85% domain        |
| `@reviewer`  | opus   | CDD/ICP + 70 rules + segurança (ApplicationSecurityMCP) — anota via codetags |

### Anti-goals (o que cada agent NÃO faz)

| Agent        | Não faz                                                               |
| ------------ | --------------------------------------------------------------------- |
| `@leader`    | Escrever código, criar testes, fazer review, criar docs arquiteturais |
| `@architect` | Implementar código, executar testes, fazer review funcional           |
| `@developer` | Decidir arquitetura/patterns, criar specs, fazer review CDD/ICP       |
| `@tester`    | Alterar código de produção, fazer review arquitetural                 |
| `@reviewer`  | Implementar código, criar testes, sincronizar docs                    |

---

## Commands

Usados diretamente no Claude Code com `/nome-do-command`:

| Comando                             | Quando usar                                                                |
| ----------------------------------- | -------------------------------------------------------------------------- |
| `/start [feature-name]`             | Inicializa `changes/00X_nome/` com templates de PRD, design, specs e tasks |
| `/status`                           | Dashboard: features em andamento, tasks concluídas, fase atual, counters   |
| `/audit [branch\|pr <n>\|src/path]` | Code review completo via @reviewer — posta resultado diretamente em PRs    |
| `/docs [src/path]`                  | Sincroniza `docs/` (arc42, c4, adr, bdd) — funciona sem Spec Flow          |
| `/ship`                             | Prepara commit Conventional Commits e envia para o remoto                  |
| `/sync`                             | Atualiza branch com últimas alterações do repositório remoto               |

### Exemplo de uso

```bash
# Iniciar uma nova feature
/start user-authentication

# Ver o que está em andamento
/status

# Commitar e publicar
/ship
```

---

## Hooks automáticos

Os 3 hooks formam uma cadeia automática — executam sem nenhuma invocação manual:

```
Usuário digita algo
    ↓
[1] prompt.sh ← UserPromptSubmit
    Detecta se é dev task → injeta hint de modo para @leader

Claude responde, escreve/edita arquivos
    ↓
[2] lint.sh ← PostToolUse (Write|Edit|NotebookEdit)
    Auto-formata com biome em todo arquivo .ts/.tsx/.js/.jsx/.json

Claude termina de responder
    ↓
[3] loop.sh ← Stop
    Verifica tasks.md — bloqueia se há tarefas pendentes ( - [ ] )
```

### Detalhes de cada hook

**`prompt.sh` — Roteamento de modo**

Quando o usuário digita um pedido com verbo de ação (`implemente`, `crie`, `corrija`, etc.), o hook injeta contexto no system prompt orientando o `@leader` a classificar o pedido antes de agir:

```bash
# Aciona roteamento
"cria endpoint POST /users"    → hint: Modo Task
"implementa OAuth2"            → hint: Modo Feature
"corrige o typo no controller" → hint: Modo Quick

# NÃO aciona (perguntas conceituais são ignoradas)
"o que é o princípio SOLID?"
"como funciona o @reviewer?"
```

**`lint.sh` — Formatação automática**

Executado após qualquer `Write` ou `Edit` em arquivos de código. Roda `bunx biome check --write` no arquivo recém-modificado. Extensões cobertas: `.ts` `.tsx` `.js` `.jsx` `.json`.

**`loop.sh` — Guardião do workflow**

Executa ao final de cada resposta do Claude. Busca `changes/*/tasks.md` e verifica se existem checkboxes não marcados (`- [ ]`). Se encontrar, bloqueia a finalização e retorna ao `@leader` para continuar.

```bash
# Escape hatch — use se o workflow travar por qualquer razão:
touch .claude/.loop-skip

# Remova após resolver:
rm .claude/.loop-skip
```

| Evento                                      | Hook        | Arquivo                   |
| ------------------------------------------- | ----------- | ------------------------- |
| `PostToolUse` — `Write\|Edit\|NotebookEdit` | `lint.sh`   | `.claude/hooks/lint.sh`   |
| `Stop`                                      | `loop.sh`   | `.claude/hooks/loop.sh`   |
| `UserPromptSubmit`                          | `prompt.sh` | `.claude/hooks/prompt.sh` |

---

## Rules (70 regras)

Regras arquiteturais organizadas por categoria. Cada regra tem: definição, critérios objetivos, exceções, como detectar (manual + automático) e cross-references bidirecionais.

| Categoria           | IDs     | Fonte                        |
| ------------------- | ------- | ---------------------------- |
| Object Calisthenics | 001–009 | Jeff Bay                     |
| SOLID               | 010–014 | Uncle Bob                    |
| Package Principles  | 015–020 | Uncle Bob                    |
| Clean Code          | 021–039 | Clean Code + práticas gerais |
| Twelve-Factor       | 040–051 | 12factor.net                 |
| Anti-Patterns       | 052–070 | Fowler + Brown               |

**Severidade:** 🔴 bloqueia PR · 🟠 exige justificativa · 🟡 melhoria esperada

**Próximo ID disponível:** `071`

### Como criar uma nova rule

```markdown
# [Título da Regra]

**ID**: [CATEGORIA-NNN ou AP-NN-NNN]
**Severidade**: [🔴 Crítica | 🟠 Alta | 🟡 Média]
**Categoria**: [Estrutural | Comportamental | Criacional | Infraestrutura]

---

## O que é

## Por que importa

## Critérios Objetivos ← checkboxes

## Exceções Permitidas

## Como Detectar ← Manual e Automático

## Relacionada com ← links tipados (reforça · complementa · substitui · depende)

---

**Criada em**: AAAA-MM-DD **Versão**: 1.0
```

---

## Skills (35 skills)

Skills são módulos de conhecimento que os agentes carregam sob demanda. Seguem o princípio de **Progressive Disclosure**: o `SKILL.md` é o índice leve; os detalhes ficam em `references/`.

| Grupo               | Skills                                                                                                 |
| ------------------- | ------------------------------------------------------------------------------------------------------ |
| Estrutura de classe | anatomy, constructor, bracket                                                                          |
| Membros             | getter, setter, method                                                                                 |
| Comportamento       | event, dataflow, render, state                                                                         |
| Dados               | enum, token, alphabetical                                                                              |
| Organização         | colocation, revelation, story                                                                          |
| Composição          | mixin, complexity                                                                                      |
| Performance         | big-o                                                                                                  |
| Anotação            | **codetags** (16 tags documentadas)                                                                    |
| Princípios OOP      | **object-calisthenics** (9 regras), **solid** (5 princípios), **package-principles** (6 princípios)    |
| Práticas de Código  | **clean-code** (rules 021–039)                                                                         |
| Metodologia         | **cdd** (Cognitive-Driven Development — ICP = CC_base + Aninhamento + Responsabilidades + Acoplamento) |
| Infraestrutura      | **twelve-factor** (12 fatores)                                                                         |
| Design Patterns     | **gof** (23 patterns), **poeaa** (51 patterns)                                                         |
| Documentação        | **arc42** (12 seções), **c4model** (4 níveis), **adr**, **bdd**                                        |
| Qualidade           | **software-quality** (McCall Model — 12 fatores)                                                       |
| Frontend            | **react** (patterns + rendering strategies 2026)                                                       |
| Anti-Patterns       | **anti-patterns** (26 patterns catalogados)                                                            |

### Template de skill

```yaml
---
name: skill-name
description: "[O que é]. Use quando [condição] — [triggers específicos]."
model: haiku|sonnet
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---
```

Body: `Quando Usar` → `Conteúdo` → `## Exemplos` (❌/✅) → `Proibições` → `Fundamentação`

---

## Grafo de dependências

`.claude/GRAPH.md` contém 4 diagramas Mermaid documentando como tudo se conecta:

1. **Camadas de rules** — OC → SOLID → Package → Clean Code → 12-Factor + Anti-Patterns
2. **Skills → Rules** — qual skill cobre quais rules
3. **Skills → Skills** — interdependências entre skills
4. **Agents → Skills → Rules** — qual agent usa o quê

---

## ICP — Integrated Cognitive Persistence

O `@reviewer` mede a carga cognitiva de cada método usando ICP:

```
ICP = CC_base + Aninhamento + Responsabilidades + Acoplamento
```

| ICP  | Status         | Ação                            |
| ---- | -------------- | ------------------------------- |
| ≤ 3  | 🟢 Excelente   | Manter                          |
| 4–6  | 🟡 Aceitável   | Considerar refatoração          |
| 7–10 | 🟠 Preocupante | Refatorar antes de nova feature |
| > 10 | 🔴 Crítico     | Obrigatório refatorar           |

Limites objetivos que definem ICP aprovado/rejeitado:

| Métrica                             | Limite | Rule |
| ----------------------------------- | ------ | ---- |
| Complexidade Ciclomática por método | ≤ 5    | 022  |
| Linhas por classe                   | ≤ 50   | 007  |
| Linhas por método                   | ≤ 15   | 055  |
| Parâmetros por função               | ≤ 3    | 033  |
| Encadeamento por linha              | ≤ 1    | 005  |
| Nível de indentação                 | ≤ 1    | 001  |

---

## Codetags

O `@reviewer` anota violações diretamente no código com tom educativo — explicando o porquê e o caminho para melhorar:

```typescript
// FIXME: Esta classe está assumindo responsabilidades demais — lida com
// autenticação e acesso ao banco ao mesmo tempo. Isso dificulta testar
// cada parte de forma independente. Separar em Repository resolve.

// TODO: Com 5 parâmetros, fica difícil saber o que cada um representa.
// Agrupar em UserCreateInput torna a chamada mais expressiva e facilita
// adicionar campos no futuro.

// XXX: O if/else aninhado funciona, mas a leitura fica cansativa.
// Retornos antecipados (guard clauses) linearizam o fluxo.

// FIXME: A query concatena input do usuário diretamente, abrindo espaço
// para SQL Injection. Prepared statements separam código de dados.
```

| Tag             | Severidade | Bloqueia PR?        |
| --------------- | ---------- | ------------------- |
| `FIXME`         | Crítica    | Sim                 |
| `TODO`          | Alta       | Não — deve corrigir |
| `XXX`           | Média      | Não — melhoria      |
| `SECURITY`      | Crítica    | Sim                 |
| `HACK`          | Alta       | Não                 |
| `OPTIMIZE`      | Média      | Não                 |
| `NOTE` / `INFO` | Baixa      | Não                 |

---

## Tecnologias

- **Runtime:** Bun
- **Linter/Formatter:** Biome
- **Linguagem:** TypeScript (framework-agnostic)
- **Tests:** `bun test --coverage` (fallback: Vitest)
- **AI:** Claude Code CLI com modelos opus/sonnet

---

## MCPs

O arquivo `.mcp.json` configura os servidores MCP disponíveis para o Claude Code neste projeto.

### MCPs ativos

| MCP            | Pacote                                | Token          | Para que serve                                                               |
| -------------- | ------------------------------------- | -------------- | ---------------------------------------------------------------------------- |
| **cloudflare** | `mcp-remote` → cloudflare docs        | Não            | Documentação de Workers, Pages, KV, R2, D1                                   |
| **context7**   | `@upstash/context7-mcp`               | Incluso        | Lookup semântico de docs de libs (React, Tailwind, Radix, etc.)              |
| **fetch**      | `@modelcontextprotocol/server-fetch`  | Não            | Busca qualquer URL e converte para Markdown — pesquisa de docs               |
| **figma**      | `figma-developer-mcp`                 | `FIGMA_TOKEN`  | Lê variáveis, componentes e layout de arquivos Figma                         |
| **github**     | `@modelcontextprotocol/server-github` | `GITHUB_TOKEN` | Gerencia PRs, issues, branches — integra com `/audit`                        |
| **memory**     | `@modelcontextprotocol/server-memory` | Não            | Knowledge graph persistente — armazena decisões de arquitetura entre sessões |
| **puppeteer**  | `puppeteer-mcp-server`                | Não            | Automação de browser — screenshots, testes visuais                           |
| **storybook**  | `mcp-remote` → localhost:6006         | Não            | Acesso aos componentes do Storybook local                                    |

### Como cada MCP é usado

**`fetch`** — Pesquisa de documentação e referências

Busca qualquer URL e converte para Markdown. Útil para consultar docs de React, Tailwind, Radix, shadcn/ui, MDN diretamente na sessão.

**`figma`** — Integração com design system

Lê variáveis de design (cores, espaçamentos, tipografia), inspeciona componentes e extrai layout para gerar código fiel ao design. Requer o app desktop do Figma aberto.

```bash
# Configurar o token:
# figma.com → Settings → Security → Personal access tokens
# Substituir SEU_FIGMA_TOKEN_AQUI no .mcp.json
```

**`github`** — Automação de PR e issues

Cria PRs, comenta em issues, lista alterações de branch, verifica status de CI/CD. Integra com o comando `/audit` para postar reviews diretamente em PRs.

```bash
# Configurar o token:
# github.com → Settings → Developer settings → Personal access tokens → Classic
# Scopes: repo, workflow
# Substituir SEU_GITHUB_TOKEN_AQUI no .mcp.json
```

**`memory`** — Contexto persistente entre sessões

Diferente do `context7` (que busca docs externas), o `memory` armazena conhecimento específico do projeto: padrões descobertos no codebase, decisões arquiteturais, convenções adotadas.

**`puppeteer`** — Browser automation

Screenshots de componentes em diferentes viewports, testes visuais, captura de estado de UI. Usado em conjunto com `/audit` para análise visual.

**`storybook`** — Componentes locais

Consulta stories existentes e gera documentação de componentes. Requer `bun run storybook` rodando em `http://localhost:6006`.

---

## Contribuindo

Contribuições são bem-vindas! Você pode:

- **Abrir uma issue** para reportar bugs ou propor novas rules/skills
- **Abrir um PR** seguindo o [CONTRIBUTING.md](CONTRIBUTING.md)
- **Iniciar uma discussão** para alinhar antes de implementar algo maior

Leia o [Código de Conduta](CODE_OF_CONDUCT.md) antes de contribuir.

---

## Licença

MIT © [Cleber de Moraes Goncalves](https://github.com/deMGoncalves)

Veja o arquivo [LICENSE](LICENSE) para detalhes.

---

_oh my claude — Workflow de trabalho e estilo pessoal de desenvolvimento assistido por IA._
