# Roadmap

O plano de evolução do oh my claude. Os itens estão agrupados por tema, não por cronograma — este é um documento vivo.

> **Contribua:** Se quiser trabalhar em algum desses itens, abra uma Discussion primeiro. Consulte [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Em Andamento

- [ ] **Índices de regras** — `.claude/rules/INDEX.md` com tabela de referência rápida das 70 regras
- [ ] **Galeria de skills** — `.claude/skills/INDEX.md` com descrições de skills e gatilhos de uso
- [ ] **Referência de agents** — cards resumo de uma página para cada um dos 6 agents

---

## Planejado

### Regras (071+)

As regras estendem as 70 existentes. Cada nova regra deve:
- Ter um ID único (próximo: `071`)
- Ser agnóstica de tecnologia
- Ter critérios objetivos e mensuráveis
- Incluir referências cruzadas bidirecionais

Áreas candidatas:
- [ ] **071** — Disciplina de versionamento de contratos de API
- [ ] **072** — Sistemas observáveis (logs estruturados + métricas nas fronteiras)
- [ ] **073** — Requisitos de idempotência para operações de escrita
- [ ] **074** — Padrão de circuit breaker para dependências externas

### Skills

- [ ] **`security`** — Referência ao OWASP Top 10 para agents
- [ ] **`testing`** — Skill de estratégia de testes abrangente (padrões de unit, integration, e2e)
- [ ] **`performance`** — Metodologia de profiling e detecção de hotspots
- [ ] **`database`** — Padrões de query, disciplina de migration, heurísticas de indexação
- [ ] **`api-design`** — Princípios de design de contratos REST/GraphQL

### Agents

- [ ] **`@security`** — Agent dedicado a revisão de segurança com integração OWASP + SAST
- [ ] **`@optimizer`** — Agent de profiling de performance (variante especializada do @deepdive)
- [ ] **`@migrator`** — Agent de planejamento e execução de migrations de banco de dados

### Comandos

- [ ] **`/check`** — Gate de qualidade pré-commit (regras + ICP) sem revisão completa
- [ ] **`/explain [path]`** — Explicação detalhada de qualquer arquivo ou módulo
- [ ] **`/migrate [from] [to]`** — Caminho guiado de migration entre tecnologias

### Hooks

- [ ] **Hook de pré-commit** — Bloqueia commits com violações críticas de regras (codetags FIXME)
- [ ] **Hook de descrição de PR** — Gera automaticamente descrição convencional de PR a partir de `changes/`

---

## Em Consideração

### Harness multi-projeto

Suporte para usar oh my claude em múltiplos projetos sem clonar o harness completo. Abordagens possíveis:
- `.claude/` com link simbólico a partir de uma instalação central
- Distribuição via gerenciador de pacotes (`npm install -g @deMGoncalves/oh-my-claude`)
- Abordagem via submódulo do Git

### Automação de aplicação de regras

Atualmente as regras são aplicadas pela consciência dos agents. Considerar:
- Plugin para ESLint/Biome que codifica as regras como análise estática
- Hook de pré-commit que bloqueia violações críticas

### Observabilidade

- Métricas de desempenho dos agents (com que frequência o @coder passa na primeira tentativa?)
- Rastreamento da frequência de violações de regras
- Tendência de cobertura ao longo do tempo

---

## Concluído (v2.0.0)

- [x] Sistema com 6 agents (@planner, @architect, @designer, @coder, @tester, @deepdive)
- [x] 5 modos de workflow (Quick, Task, Feature, Research, UI)
- [x] Design de agents agnóstico de tecnologia
- [x] Tradução completa para português da documentação interna
- [x] Revisão arquitetural integrada ao @architect (absorveu o @reviewer)
- [x] Planejamento especializado no @planner (absorveu o @leader)

## Concluído (v1.0.0)

- [x] 70 regras arquiteturais (001–070)
- [x] 35 skills de conhecimento
- [x] Workflow em 3 fases (Quick/Task/Feature)
- [x] 3 hooks automáticos (prompt.sh, lint.sh, loop.sh)
- [x] 5 comandos (/start, /status, /audit, /docs, /ship)

---

**Voltar ao [README.md](README.md)**
