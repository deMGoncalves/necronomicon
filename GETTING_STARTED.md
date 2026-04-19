# Primeiros Passos com oh my claude

Este guia leva você do zero ao seu primeiro workflow assistido por IA em menos de 5 minutos.

---

## Pré-requisitos

| Requisito | Finalidade | Instalação |
|-----------|-----------|-----------|
| [Claude Code](https://claude.ai/code) | Executar agents e workflow | Veja a documentação oficial |
| [GitHub CLI](https://cli.github.com) | Usado por `/audit` e `/ship` | `brew install gh` |
| [jq](https://jqlang.github.io/jq/) | Parsing de JSON nos hooks | `brew install jq` |

> **Nota:** Nenhum runtime, test runner ou linter específico é necessário. oh my claude é agnóstico de tecnologia — funciona com qualquer stack de projeto.

---

## Passo 1 — Clonar e abrir

```bash
git clone https://github.com/deMGoncalves/oh-my-claude
cd oh-my-claude
claude .
```

O Claude Code detecta automaticamente `.claude/` e carrega todos os agents, rules, skills e hooks. O prompt deve estar pronto para uso.

---

## Passo 2 — Configurar integrações opcionais

Para integração com GitHub (usada por `/audit` e `/ship`):

```bash
gh auth login
```

Para integrações MCP, edite `.mcp.json` e substitua os placeholders de token por valores reais.

---

## Passo 3 — Execute sua primeira task Quick

Digite uma requisição direta no Claude Code:

```
Fix the typo in UserController.ts line 42
```

O hook `prompt.sh` detecta o verbo de ação, injeta uma dica de modo, e o Tech Lead roteia diretamente para `@coder` (modo Quick — nenhum `changes/` necessário).

---

## Passo 4 — Inicie uma Task

Para qualquer coisa que exija uma nova interface ou contrato:

```
/start user-roles
```

Isso cria `changes/001_user-roles/` com os templates. O workflow executa:

```
@planner → @architect → @coder → @tester → revisão do @architect
```

Verifique o progresso a qualquer momento:

```
/status
```

---

## Passo 5 — Execute uma Feature

Para novos contextos delimitados com incerteza arquitetural:

```
Implement OAuth2 authentication with Google
```

O hook detecta "implement" + "auth" e sugere o modo Feature. O fluxo completo de spec em 4 fases é executado:

| Fase | Agent | Saída |
|------|-------|-------|
| 1. Planejar | @planner | `tasks.md` + `PRD.md` |
| 2. Especificar | @architect | `specs.md` + `design.md` |
| 3. Codificar | @coder → @tester | Código testado |
| 4. Documentar | @architect | `docs/` atualizado |

---

## Passo 6 — Entregue seu trabalho

```
/ship
```

Isso prepara um commit e envia para o repositório remoto.

---

## Referência do Workflow

### Os 5 Modos

| Modo | Usar quando | Como acionar |
|------|-------------|-------------|
| **Quick** | ≤2 arquivos, sem nova entidade | Requisição direta (ex.: "fix X in Y") |
| **Task** | Novo contrato, escopo claro | `/start nome-da-task` |
| **Feature** | Novo contexto delimitado | Descrever a feature (ex.: "implement X") |
| **Research** | Causa raiz desconhecida | "Why does X happen?" ou "investigate Y" |
| **UI** | Componente visual | "Create component X" ou "design Y" |

### Os 6 Agents

| Agent | Modelo | Ideal para |
|-------|--------|-----------|
| `@planner` | Opus | "Plan the implementation of X" |
| `@architect` | Opus | "Design the interface for X" |
| `@designer` | Sonnet | "Spec the component X" |
| `@coder` | Sonnet | "Implement X following specs" |
| `@tester` | Sonnet | "Write tests for X" |
| `@deepdive` | Opus | "Investigate why X fails" |

### Comandos Principais

```
/start [nome]          # Inicializa nova Feature ou Task
/status                # Vê todas as features ativas e o progresso
/audit [alvo]          # Revisão completa de código (branch, PR ou caminho)
/docs [caminho]        # Sincroniza documentação arquitetural
/ship                  # Commit + push das mudanças
/sync                  # Atualiza branch com o remoto
```

### Escape Hatch do Loop

Se o guardião do workflow (`loop.sh`) estiver bloqueando você:

```bash
touch .claude/.loop-skip
# Resolva o problema que está bloqueando
rm .claude/.loop-skip
```

---

## Próximos Passos

- Leia `.claude/CLAUDE.md` para a referência completa de orquestração do Tech Lead
- Leia `.claude/agents/` para entender o papel e os limites de cada agent
- Leia `.claude/rules/` para explorar as 70 rules arquiteturais (001–070)
- Leia `.claude/skills/` para ver as skills disponíveis por contexto

---

**Voltar para [README.md](README.md)**
