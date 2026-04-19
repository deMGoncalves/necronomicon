# Referência de Workflow

Fluxo de trabalho pessoal de desenvolvimento assistido por IA codificado em agentes, regras e skills para [Claude Code](https://code.claude.com). Este arquivo documenta como `.claude/` funciona.

---

## Estrutura

```
.claude/
├── CLAUDE.md          ← hub central (carregado automaticamente pelo Claude Code)
├── GRAPH.md           ← mapa de dependências entre regras, skills e agentes (Mermaid)
├── agents/            ← 6 agentes especializados
├── skills/            ← 35 skills (código + arquitetura + qualidade)
├── rules/             ← 70 regras arquiteturais (001–070)
├── commands/          ← 6 comandos de workflow
├── hooks/             ← hooks automáticos (prompt, lint, security, guard, loop, telemetry)
├── telemetry/         ← traces JSON (sessions.jsonl, intent.jsonl)
└── settings.json      ← permissões + configuração de hooks

changes/               ← contexto persistente de features (criado por feature/task)
└── 00X_feature-name/
    ├── PRD.md         ← (somente Feature) requisitos + regras de negócio
    ├── design.md      ← (somente Feature) decisões técnicas + padrões
    ├── design-spec.md ← (somente UI) especificação de componente + tokens
    ├── specs.md       ← (Task + Feature) interfaces + critérios de aceitação
    ├── findings.md    ← (somente Research) relatório de investigação
    └── tasks.md       ← T-001…T-NNN + contadores de tentativas

docs/                  ← documentação arquitetural sincronizada
├── arc42/             ← 12 seções arquiteturais
├── c4/                ← 4 níveis de abstração
├── adr/               ← Architecture Decision Records
└── bdd/               ← features Gherkin
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
 │  │ prompt.sh    │  │  /start        │  │  🔵 @planner    │   │
 │  │ ↳ hint modo  │  │  /status       │  │  🟢 @architect  │   │
 │  │              │  │  /audit        │  │  🟡 @coder      │   │
 │  │ lint.sh      │  │  /docs         │  │  🔴 @tester     │   │
 │  │ ↳ biome fmt  │  │  /ship  /sync  │  │  🩵 @designer   │   │
 │  │              │  │                │  │  🟣 @deepdive   │   │
 │  │ loop.sh      │  └────────────────┘  └────────┬────────┘   │
 │  │ ↳ tasks.md   │                               │            │
 │  └──────┬───────┘                               │            │
 │         └───────────────────────────────────────┘            │
 │                              │ carrega                       │
 │  ┌───────────────────────────▼───────────────────────────┐   │
 │  │   skills/ (35)                    rules/ (70)         │   │
 │  │                                                       │   │
 │  │  cdd · codetags · complexity    001–009 Object Cal.   │   │
 │  │  solid · gof · poeaa            010–014 SOLID         │   │
 │  │  colocation · clean-code · ...  052–070 Anti-Patterns │   │
 │  └───────────────────────────────────────────────────────┘   │
 └──────────────────────────────────────────────────────────────┘
```

### Fluxo de tarefas

```
  entrada do usuário
       │
  ┌────▼───────────────────────────────────────────┐
  │ prompt.sh — detecta verbo de ação → injeta modo │
  └────┬───────────────────────────────────────────┘
       │
  ┌────▼─────────────────────────────────────────────────┐
  │               Tech Lead (Claude Code)                │
  │   classifica → Quick / Task / Feature / Research / UI│
  └────┬─────────────────────┬──────────────┬────────────┘
       │                     │              │
    Quick                  Task          Feature
       │                     │              │
       │              ┌──────▼──────┐  ┌───▼──────────────┐
       │              │ 🟢 @arch    │  │   🟢 @architect   │
       │              │ specs leves │  │ PRD+design+specs │
       │              └──────┬──────┘  └───┬──────────────┘
       │                     │             │
       └─────────────────────┴─────────────┘
                             │
                  src/[context]/[container]/[component]/
                             │
  ┌──────────────────────────▼────────────────────────────┐
  │ 🟡 @coder — controller · service · model · repo       │
  └──────────────────────────┬────────────────────────────┘
                  [lint.sh → biome format a cada Write]
  ┌──────────────────────────▼────────────────────────────┐
  │ 🔴 @tester — bun test --coverage  ≥ 85% domínio       │
  └──────────────────────────┬────────────────────────────┘
  ┌──────────────────────────▼────────────────────────────┐
  │ 🟢 @architect (review) — ICP · 70 regras · segurança  │
  │                          codetags educacionais        │
  └────────────┬─────────────────────────┬────────────────┘
               │                         │
         ✅ Aprovado               ❌ Rejeitado
               │                    ↩ @coder (até 3x)
  [loop.sh verifica tasks.md · bloqueia se - [ ] existe]
```

---

## Como funciona

Toda solicitação de desenvolvimento é classificada pelo Tech Lead **antes de qualquer ação**:

### Modo Quick — 🟡 @coder direto

Para mudanças pontuais em ≤ 2 arquivos sem nova entidade de domínio.

```
"corrigir typo no UserController"
"remover console.log de src/"
"ajustar timeout de 30s para 60s"
    ↓
🟡 @coder → 🔴 @tester → 🟢 @architect review → Pronto
```

### Modo Task — specs leves + Code

Para novo contrato de interface, escopo claro, sem incerteza arquitetural.

```
"adicionar endpoint POST /users/:id/roles"
"integrar SendGrid no fluxo de registro"
    ↓
changes/00X/ + 🟢 @architect specs.md
    ↓
🟡 @coder → 🔴 @tester → 🟢 @architect review → Pronto
```

### Modo Feature — Fluxo Full Spec

Para nova entidade de domínio, incerteza técnica, impacto arquitetural amplo.

```
"implementar autenticação OAuth2 com Google"
"criar módulo de cobrança com Stripe"
    ↓
Fase 1: 🔵 @planner cria tasks.md + PRD
Fase 2: 🟢 @architect cria specs.md + design.md
Fase 3: 🟡 @coder → 🔴 @tester → 🟢 @architect review (loops ≤ 3x)
Fase 4: 🟢 @architect Docs Sync (arc42, c4, adr, bdd)
```

### Loop de feedback (Fase 3)

```
🟡 @coder → 🔴 @tester ──(falhou ≤3x)──→ 🟡 @coder
                  │
               (passou)
                  ↓
        🟢 @architect review ──(rejeitado ≤3x)──→ 🟡 @coder
                  │                                    │
              (aprovado)              (attempts-coder ≥ 3)
                  ↓                                    ↓
          Tech Lead finaliza             Tech Lead → Re-Spec
         (Docs se Feature)          (🟢 @architect revisa specs.md)
```

---

## Agentes

| Agente       | Modelo | Papel                                                                           |
| ------------ | ------ | ------------------------------------------------------------------------------- |
| `@planner`   | opus   | Classifica + decompõe + cria `changes/` — orquestra sequência de agentes        |
| `@architect` | opus   | Specs técnicas (interfaces, padrões) + docs sync + revisão arquitetural (CDD/ICP)|
| `@designer`  | sonnet | Specs de UI/UX + design tokens + acessibilidade (WCAG) + Storybook              |
| `@coder`     | sonnet | Implementa via specs.md ou pedido direto (Quick) — aplica 70 regras             |
| `@tester`    | sonnet | Avaliador: gera testes + executa + emite pass/fail — cobertura ≥85% domínio     |
| `@deepdive`  | opus   | Investigação profunda — bugs, performance, segurança, pesquisa de tecnologia    |

### Anti-goals (o que cada agente NÃO faz)

| Agente       | Não faz                                                              |
| ------------ | -------------------------------------------------------------------- |
| `@planner`   | Escrever código, criar specs técnicas, testar, investigar            |
| `@architect` | Implementar código, executar testes, gerenciar workflow              |
| `@designer`  | Escrever produção, decidir arquitetura técnica, executar testes      |
| `@coder`     | Decidir arquitetura/padrões, criar specs, fazer review CDD/ICP       |
| `@tester`    | Alterar código de produção, fazer revisão arquitetural               |
| `@deepdive`  | Implementar código, criar planos, tomar decisões de implementação    |

Prompts completos de sistema em `agents/`.

---

## Comandos

| Comando                             | Quando usar                                                                      |
| ----------------------------------- | -------------------------------------------------------------------------------- |
| `/start [feature-name]`             | Inicializa `changes/00X_name/` com templates de PRD, design, specs e tasks      |
| `/status`                           | Dashboard: features em andamento, tarefas concluídas, fase atual, contadores    |
| `/audit [branch\|pr <n>\|src/path]` | Revisão completa de código via @architect (review) — posta resultado diretamente em PRs   |
| `/docs [src/path]`                  | Sincroniza `docs/` (arc42, c4, adr, bdd) — funciona sem Spec Flow               |
| `/ship`                             | Prepara commit Conventional Commits e empurra para remote                       |
| `/sync`                             | Atualiza branch com últimas mudanças do repositório remoto                      |

Prompts completos em `commands/`.

---

## Hooks automáticos

Os hooks formam uma cadeia automática — executam sem qualquer invocação manual:

```
Usuário digita algo
    ↓
[1] prompt.sh ← UserPromptSubmit
    Detecta se é tarefa dev → injeta hint de modo para o Tech Lead
    Registra intent em .claude/telemetry/intent.jsonl

Claude responde, escreve/edita arquivos
    ↓
[2] lint.sh | security.sh | guard.sh ← PostToolUse (Write|Edit|NotebookEdit)
    lint.sh      → auto-formata arquivos .ts/.tsx/.js/.jsx/.json
    security.sh  → bloqueia se credencial hardcoded for detectada
    guard.sh     → bloqueia se violação de regra 🔴 Crítica for detectada

Claude termina de responder
    ↓
[3] loop.sh → telemetry.sh ← Stop
    loop.sh       → verifica tasks.md — bloqueia se existir - [ ] pendente
    telemetry.sh  → registra trace JSON em .claude/telemetry/sessions.jsonl
```

### Detalhes de cada hook

**`prompt.sh` — Roteamento de modo**

Detecta verbos de ação no prompt do usuário e injeta um hint de modo no system prompt para que o Tech Lead classifique antes de agir:

```bash
"criar endpoint POST /users"    → hint: Modo Task
"implementar OAuth2"             → hint: Modo Feature
"corrigir typo no controller"   → hint: Modo Quick

# NÃO dispara (perguntas conceituais são ignoradas)
"o que é princípio SOLID?"
"como funciona @reviewer?"
```

**`lint.sh` — Formatação automática**

Executa `bunx biome check --write` em todo arquivo escrito ou editado. Extensões cobertas: `.ts` `.tsx` `.js` `.jsx` `.json`.

**`loop.sh` — Guardião do workflow**

Busca `changes/*/tasks.md` por itens não marcados (`- [ ]`). Se algum existir, bloqueia a resposta e retorna ao `@leader` para continuar.

```bash
# Escape hatch — usar se o workflow ficar travado:
touch .claude/.loop-skip
rm .claude/.loop-skip  # remover após resolver
```

| Evento                                      | Hook           | Objetivo                                                                                                             |
| ------------------------------------------- | -------------- | -------------------------------------------------------------------------------------------------------------------- |
| `UserPromptSubmit`                          | `prompt.sh`    | Injeta hint de modo (Quick/Task/Feature/Research/UI) + registra intent em `.claude/telemetry/intent.jsonl`           |
| `PostToolUse` — `Write\|Edit\|NotebookEdit` | `lint.sh`      | Auto-formata arquivos `.ts/.tsx/.js/.jsx/.json` com `bunx biome check --write`                                       |
| `PostToolUse` — `Write\|Edit\|NotebookEdit` | `security.sh`  | Bloqueia escrita se credencial hardcoded for detectada                                                               |
| `PostToolUse` — `Write\|Edit\|NotebookEdit` | `guard.sh`     | Bloqueia escrita se violação de regra 🔴 Crítica for detectada                                                       |
| `Stop`                                      | `loop.sh`      | Bloqueia encerramento se existir `- [ ]` pendente em `changes/*/tasks.md` + exibe contadores                         |
| `Stop`                                      | `telemetry.sh` | Registra trace JSON (session_id, mode, tasks, attempts, violations) em `.claude/telemetry/sessions.jsonl`            |

---

## Regras (70)

Regras arquiteturais organizadas por categoria. Cada regra tem: definição, critérios objetivos, exceções, como detectar (manual + automático) e referências cruzadas bidirecionais.

| Categoria           | IDs     | Fonte                          |
| ------------------- | ------- | ------------------------------ |
| Object Calisthenics | 001–009 | Jeff Bay                       |
| SOLID               | 010–014 | Uncle Bob                      |
| Package Principles  | 015–020 | Uncle Bob                      |
| Clean Code          | 021–039 | Clean Code + práticas gerais   |
| Twelve-Factor       | 040–051 | 12factor.net                   |
| Anti-Patterns       | 052–070 | Fowler + Brown                 |

**Severidade:** 🔴 bloqueia PR · 🟠 requer justificativa · 🟡 melhoria esperada

**Próximo ID disponível:** `071`

Regras completas em `rules/`.

---

## Skills (35)

Módulos de conhecimento que agentes carregam sob demanda. Seguem o princípio de **Progressive Disclosure** em 3 níveis — o runtime carrega apenas o necessário a cada etapa:

| Nível | Conteúdo                                                                 | Quando é carregado                                                    |
| ----- | ------------------------------------------------------------------------ | --------------------------------------------------------------------- |
| 1     | Frontmatter YAML (`name` + `description`)                                | Discovery — runtime varre todos os skills para indexação              |
| 2     | Seção `## Manifest` (applicability, prerequisites, constraints, scope)   | Candidato — skill foi selecionado como potencialmente relevante       |
| 3     | Arquivos em `references/`                                                 | Ativo — skill está em uso efetivo durante a execução                  |

Exemplos do padrão nível 2: `skills/clean-code/SKILL.md` e `skills/colocation/SKILL.md` declaram `## Manifest` para expor ao runtime quando o detalhe em `references/` vale ser carregado.

| Grupo           | Skills                                                                                             |
| --------------- | -------------------------------------------------------------------------------------------------- |
| Estrutura de classe | anatomy, constructor, bracket                                                                  |
| Membros         | getter, setter, method                                                                             |
| Comportamento   | event, dataflow, render, state                                                                     |
| Dados           | enum, token, alphabetical                                                                          |
| Organização     | colocation, revelation, story                                                                      |
| Composição      | mixin, complexity                                                                                  |
| Performance     | big-o                                                                                              |
| Anotação        | **codetags** (16 tags documentadas)                                                                |
| Princípios OOP  | **object-calisthenics** (9 regras), **solid** (5 princípios), **package-principles** (6 princípios) |
| Práticas de código | **clean-code** (regras 021–039)                                                                 |
| Metodologia     | **cdd** (Cognitive-Driven Development — ICP = CC_base + Nesting + Responsibilities + Coupling)     |
| Infraestrutura  | **twelve-factor** (12 fatores)                                                                     |
| Padrões de design | **gof** (23 padrões), **poeaa** (51 padrões)                                                    |
| Documentação    | **arc42** (12 seções), **c4model** (4 níveis), **adr**, **bdd**                                   |
| Qualidade       | **software-quality** (Modelo McCall — 12 fatores)                                                  |
| Frontend        | **react** (padrões + estratégias de renderização 2026)                                            |
| Anti-Patterns   | **anti-patterns** (26 padrões catalogados)                                                         |

Skills completas em `skills/`.

### Ciclo de Skill Distillation

Quando uma Task ou Feature é concluída com `attempts-coder: 1` e tester aprova na primeira tentativa, o `specs.md` e o histórico do `tasks.md` são candidatos a refinamento de skill:

1. Revisar `changes/*/specs.md` — padrões recorrentes → candidatos a novo skill ou update
2. Identificar qual skill cobriu o cenário → abrir o `SKILL.md` e adicionar exemplo ou constraint
3. Se padrão é novo (não coberto por nenhum skill) → criar novo skill com `/start nome-skill`
4. Registrar a decisão de não-criar com codetag `// NOTE: padrão X já coberto por skill Y`

**Gatilho automático**: `attempts-coder: 1` + tester pass → revisar skills relacionados ao modo da feature.

---

## ICP — Integrated Cognitive Persistence

`@architect` (em modo review) mede carga cognitiva de cada método usando ICP:

```
ICP = CC_base + Nesting + Responsibilities + Coupling
```

| ICP  | Status        | Ação                           |
| ---- | ------------- | ------------------------------ |
| ≤ 3  | 🟢 Excelente  | Manter                         |
| 4–6  | 🟡 Aceitável  | Considerar refatoração         |
| 7–10 | 🟠 Preocupante | Refatorar antes de nova feature |
| > 10 | 🔴 Crítica    | Refatoração obrigatória        |

Limites objetivos que definem ICP aprovado/rejeitado:

| Métrica                            | Limite | Regra |
| ---------------------------------- | ------ | ----- |
| Complexidade Ciclomática por método | ≤ 5    | 022   |
| Linhas por classe                  | ≤ 50   | 007   |
| Linhas por método                  | ≤ 15   | 055   |
| Parâmetros por função              | ≤ 3    | 033   |
| Encadeamento por linha             | ≤ 1    | 005   |
| Nível de indentação                | ≤ 1    | 001   |

---

## Codetags

`@architect` (em modo review) anota violações diretamente no código com tom educacional — explicando o porquê e o caminho para melhorar. Nunca referencie arquivos de configuração internos.

| Tag             | Severidade | Bloqueia PR?        |
| --------------- | ---------- | ------------------- |
| `FIXME`         | Crítica    | Sim                 |
| `TODO`          | Alta       | Não — deve corrigir |
| `XXX`           | Média      | Não — melhoria      |
| `SECURITY`      | Crítica    | Sim                 |
| `HACK`          | Alta       | Não                 |
| `OPTIMIZE`      | Média      | Não                 |
| `NOTE` / `INFO` | Baixa      | Não                 |

```typescript
// FIXME: Esta classe está assumindo muitas responsabilidades — lida tanto com
// autenticação quanto acesso a banco de dados. Isso dificulta testar cada parte
// independentemente. Separar em Repository resolve isso.

// TODO: Com 5 parâmetros, fica difícil saber o que cada um representa.
// Agrupar em UserCreateInput torna a chamada mais expressiva.

// XXX: O if/else aninhado funciona, mas a leitura é cansativa.
// Retornos antecipados (guard clauses) linearizam o fluxo.
```

Referência completa de tags em `skills/codetags/`.

---

## Observabilidade

O harness emite dois fluxos de telemetria em formato JSON Lines — um registro por linha, pronto para ingestão em pipelines de análise.

| Arquivo                              | Origem         | Evento              | Conteúdo do registro                                                                    |
| ------------------------------------ | -------------- | ------------------- | --------------------------------------------------------------------------------------- |
| `.claude/telemetry/intent.jsonl`     | `prompt.sh`    | `UserPromptSubmit`  | Intent detectado por prompt (modo sugerido, verbo de ação, timestamp, session_id)       |
| `.claude/telemetry/sessions.jsonl`   | `telemetry.sh` | `Stop`              | Trace por sessão: `timestamp`, `session_id`, `cwd`, `feature`, `mode`, `tasks` (pending/done), `attempts` (coder/tester), `violations` |

Os dois arquivos crescem apenas por append, nunca são reescritos pelos hooks, e podem ser consumidos por qualquer ferramenta que leia JSONL. A pasta `.claude/telemetry/` deve ficar fora do versionamento (já coberta pelo `.gitignore` local).

---

## Grafo de dependências

`GRAPH.md` contém 4 diagramas Mermaid:

1. **Camadas de regras** — OC → SOLID → Package → Clean Code → 12-Factor + Anti-Patterns
2. **Skills → Regras** — qual skill cobre quais regras
3. **Skills → Skills** — interdependências entre skills
4. **Agentes → Skills → Regras** — qual agente usa o quê
