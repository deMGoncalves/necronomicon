# oh my claude

Você está no projeto de **Cleber de Moraes Goncalves** ([@deMGoncalves](https://github.com/deMGoncalves)).
Este é o workflow pessoal de desenvolvimento assistido por IA. Siga as convenções abaixo em toda interação.

---

## Ao receber um pedido de desenvolvimento

**Classifique primeiro.** Antes de qualquer ação, determine o modo:

| Modo | Quando | O que fazer |
|------|--------|-------------|
| **Quick** | Fix pontual, ≤ 2 arquivos, sem nova entidade | Ir direto ao @developer |
| **Task** | Novo contrato de interface, escopo claro | Criar `changes/00X/` + pedir specs ao @architect |
| **Feature** | Nova entidade, incerteza técnica, impacto amplo | Executar as 4 fases completas |

Se o pedido for ambíguo, pergunte ao usuário qual modo preferir antes de prosseguir.

### Heurística rápida

1. Muda ≤ 2 arquivos existentes sem novo contrato? → **Quick**
2. Tem interface nova mas domínio existente? → **Task**
3. Novo bounded context, auth, ou impacto em N módulos? → **Feature**

---

## Agents disponíveis

Consulte `.opencode/agents/` para o system prompt completo de cada agent.

| Agent | Cor | Quando usar |
|-------|-----|-------------|
| @leader | blue | Orquestração — classifica, delega, gerencia re-spec |
| @architect | green | Research (PRD+design+specs) ou specs light |
| @developer | yellow | Implementação (Quick: pedido direto / Task+Feature: via specs.md) |
| @tester | red | Testes — `bun test --coverage` — cobertura ≥85% domain |
| @reviewer | purple | Code review — CDD/ICP + 70 rules + segurança |

**Loops de feedback são limitados a 3 iterações.** Após 3 falhas do @developer, acione re-spec via @architect.

---

## Skills disponíveis

Localização: `.opencode/skills/` — cada skill tem um `SKILL.md` com o conteúdo de referência.

| Contexto | Skills |
|----------|--------|
| Revisão de código | `cdd`, `codetags`, `software-quality`, `complexity` |
| Implementação | `complexity`, `codetags`, `clean-code`, `anti-patterns` |
| Estrutura de src/ | `colocation` — toda implementação usa vertical slice `src/[context]/[container]/[component]/` |
| Design arquitetural | `gof`, `poeaa`, `solid`, `package-principles` |
| Documentação | `arc42`, `c4model`, `adr`, `bdd` |
| Infraestrutura | `twelve-factor` |
| Frontend React | `react` |

---

## Regras (70)

Localização: `.opencode/rules/`. Severidade:
- 🔴 **Crítica** — não submeter código com violação
- 🟠 **Alta** — corrigir antes de entregar
- 🟡 **Média** — anotar com codetag

| Categoria | IDs |
|-----------|-----|
| Object Calisthenics | 001–009 |
| SOLID | 010–014 |
| Package Principles | 015–020 |
| Clean Code | 021–039 |
| Twelve-Factor | 040–051 |
| Anti-Patterns | 052–070 |

Próximo ID disponível: `071`

---

## Codetags

Ao identificar violações, anote diretamente no código com **tom educativo** — explique o porquê, o impacto e o caminho para melhorar. Nunca referencie arquivos de configuração internos.

Tags disponíveis: `FIXME` (crítica), `TODO` (alta), `XXX` (média), `SECURITY` (crítica), `OPTIMIZE` (média), `NOTE` / `INFO` (baixa)

```typescript
// FIXME: Esta função concatena input do usuário diretamente na query, abrindo
// espaço para SQL Injection. Prepared statements resolvem isso separando
// o código dos dados — e ainda deixam o código mais legível.

// TODO: Com 5 parâmetros, fica difícil saber o que cada um representa na
// chamada. Agrupar em um objeto de configuração torna a intenção clara e
// facilita adicionar campos sem quebrar quem já usa o método.

// XXX: O if/else aninhado funciona, mas a leitura fica cansativa. Retornos
// antecipados (guard clauses) linearizam o fluxo — cada condição fica
// evidente sem precisar acompanhar o aninhamento.
```

---

## Commands

Use os commands em `.opencode/commands/` para operações de workflow:

| Command | Quando acionar |
|---------|---------------|
| `/start [nome]` | Inicializar nova Feature ou Task |
| `/status` | Ver progresso de features em andamento |
| `/audit [branch\|pr <n>\|src/path]` | Code review completo via @reviewer |
| `/docs [path]` | Sincronizar documentação arquitetural |
| `/ship` | Commitar e publicar alterações |
| `/sync` | Atualizar branch com remoto |

---

## Contexto persistente

Cada Feature/Task mantém contexto em `changes/00X_nome/`:
- `PRD.md` — (só Feature) requisitos e regras de negócio
- `design.md` — (só Feature) decisões técnicas e patterns
- `specs.md` — interfaces, contratos, critérios de aceite
- `tasks.md` — tarefas + counters: `<!-- attempts-developer: 0 -->`, `<!-- attempts-tester: 0 -->`, `<!-- attempts-reviewer: 0 -->`

---

## Comportamentos automáticos (substituem hooks)

O OpenCode não suporta hooks como o Claude Code. Compense com estes comportamentos obrigatórios:

| Momento | Comportamento |
|---------|--------------|
| Após editar `.ts/.tsx/.js/.jsx/.json` | Executar `bunx biome check --write <arquivo>` antes de continuar |
| Antes de finalizar qualquer tarefa | Verificar `changes/*/tasks.md` por `- [ ]` pendentes — se houver, continuar antes de encerrar |
| Ao receber pedido de desenvolvimento | Classificar em Quick/Task/Feature antes de agir (ver seção acima) |

**Escape hatch:** Se o workflow travar, verifique `changes/*/tasks.md` e marque tarefas bloqueadas como concluídas com nota explicativa.

---

## Grafo de dependências

Consulte `.opencode/GRAPH.md` para o mapa completo de dependências entre rules, skills e agents.
