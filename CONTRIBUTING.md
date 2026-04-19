# Como Contribuir

Obrigado por querer contribuir com o **oh my claude**! Este projeto é um workflow de desenvolvimento assistido por IA — sua contribuição pode ajudar outros desenvolvedores a escrever código melhor com o Claude Code.

## O que você pode contribuir

| Tipo | Descrição | Onde fica |
|------|-----------|-----------|
| **Nova rule** | Rule arquitetural com critérios objetivos | `.claude/rules/` |
| **Nova skill** | Módulo de conhecimento para agents | `.claude/skills/` |
| **Novo command** | Command invocável com `/nome` | `.claude/commands/` |
| **Melhoria de agent** | Refinamento de agent existente | `.claude/agents/` |
| **Correção de bug** | Erro em hook, command ou agent | Onde o bug está |
| **Documentação** | Melhoria no README ou markdowns | Raiz do projeto |
| **Novo agent** | Novo agent especializado | `.claude/agents/` |
| **Novo modo** | Novo modo de workflow (Quick/Task/Feature/Research/UI) | `.claude/CLAUDE.md` |

---

## Adicionando uma Rule

Crie o arquivo em `.claude/rules/` seguindo o template:

```markdown
# [Título da Rule]

**ID**: [CATEGORIA-NNN]
**Severidade**: [🔴 Crítica | 🟠 Alta | 🟡 Média]
**Categoria**: [Estrutural | Comportamental | Criacional | Infraestrutura]

---

## O que é

[Descrição clara e concisa]

## Por que importa

[Impacto no código e na manutenibilidade]

## Critérios Objetivos

- [ ] [Critério mensurável 1]
- [ ] [Critério mensurável 2]

## Exceções Permitidas

- [Quando a rule pode ser ignorada]

## Como Detectar

### Manual
[O que verificar no código]

### Automático
[Ferramenta e configuração: ESLint, Biome, SonarQube]

## Relacionada com

- [NNN - Nome da Rule](NNN_nome.md): [tipo de relacionamento]

---

**Criada em**: AAAA-MM-DD  **Versão**: 1.0
```

**Rules para ID:**
- Object Calisthenics: `001–009` (próximo: `010`)
- SOLID: `010–014`
- Princípios de Pacote: `015–020`
- Clean Code: `021–039`
- Twelve-Factor: `040–051`
- Anti-Patterns: `052–070`
- **Novas rules:** próximo ID disponível é `071` (veja `.claude/CLAUDE.md` para o mais alto atual)

---

## Adicionando um Agent

Crie um novo arquivo em `.claude/agents/nome-do-agent.md`:

```yaml
---
name: nome-do-agent
description: "[Papel em uma linha]. [Quando usar — gatilho específico]."
model: sonnet        # sonnet para implementação, opus para raciocínio profundo
tools: Read, Write, Edit, Bash, Glob, Grep
color: [qualquer nome de cor]
---
```

**Estrutura do corpo:**
```
## Papel
[Descrição de responsabilidade única]

## Anti-objetivos
[O que este agent explicitamente NÃO faz]

## Contrato de Entrada
[Tabela Entrada → Saída]

## Contrato de Saída
[O que a saída deve conter]

## Skills
[Tabela Contexto → Skills]

## Regras
[Tabela Severidade → IDs → Ação]

## Fluxo de Trabalho
[Tabela passo a passo]

## Tratamento de Erros
[Tabela Situação → Ação]

## Critérios de Conclusão
[Tabela Status → Critérios mensuráveis]
```

**Princípios de design de agents:**
- Responsabilidade única — um agent, um trabalho
- Contratos explícitos de entrada/saída
- Loops limitados (máximo 3 tentativas rastreadas em tasks.md)
- Agnóstico de tecnologia — sem nomes de ferramentas específicas no texto
- Idioma: português para todo o conteúdo

---

## Adicionando uma Skill

Crie o diretório em `.claude/skills/nome-da-skill/` com `SKILL.md`:

```yaml
---
name: nome-da-skill          # kebab-case
description: "[O que é]. Usar quando [condição] — [gatilhos específicos]."
model: haiku               # haiku para referência rápida, sonnet para análise
allowed-tools: Read        # mínimo necessário
metadata:
  author: SeuNome
  version: "1.0.0"
---
```

**Estrutura do corpo:**
```
## Quando Usar
## [Conteúdo principal]
## Exemplos (❌ Ruim / ✅ Bom)
## Proibições
## Justificativa  ← links para rules relacionadas
```

Para skills com muito conteúdo, use `references/`:
```
nome-da-skill/
├── SKILL.md          ← índice leve
└── references/
    └── detalhe.md     ← conteúdo carregado sob demanda
```

---

## Adicionando um Command

Crie o arquivo em `.claude/commands/nome.md`:

```yaml
---
description: "[Uso principal em ≤ 250 chars, informação mais importante primeiro]"
argument-hint: "[args esperados]"  # opcional
allowed-tools: Tool, Bash(comando específico *)
---

## Propósito

[1-2 linhas + contexto ao vivo com !`comando`]

## Instruções

1. [Passo 1]
2. [Passo 2]
```

---

## Processo de Pull Request

1. **Fork** do repositório
2. **Crie um branch** com nome descritivo:
   - `rule/071-nome-da-rule`
   - `skill/nome-da-skill`
   - `fix/descricao-do-bug`
   - `agent/nome-do-agent`
   - `docs/descricao-da-melhoria`
3. **Implemente** seguindo os templates acima
4. **Adicione ao CHANGELOG.md** na seção `[Unreleased]`
5. **Abra um Pull Request** com o template preenchido

### Checklist de qualidade

Para **rules:**
- [ ] ID único na categoria correta
- [ ] Critérios objetivos e mensuráveis (não subjetivos)
- [ ] Referências cruzadas bidirecionais com rules relacionadas
- [ ] Severidade justificada

Para **skills:**
- [ ] Frontmatter completo com `metadata.author`
- [ ] Seção `## Exemplos` com ❌/✅
- [ ] `## Justificativa` com links para rules
- [ ] Descrição com gatilhos específicos (≤ 250 chars)

Para **commands:**
- [ ] Testado com Claude Code CLI
- [ ] `allowed-tools` com permissões mínimas
- [ ] Injeção de contexto ao vivo com `` !`cmd` `` onde aplicável
- [ ] `$ARGUMENTS` usado onde o command aceita args

---

## Padrões de código

- **Idioma:** português para documentação, inglês para código TypeScript
- **Nomes de arquivos:** `kebab-case`
- **Codetags:** educativos — explique o porquê, não apenas o quê
- **Agents:** agnósticos de tecnologia — sem nomes de ferramentas específicas no texto dos agents
- **Exemplos:** sempre `❌ Ruim` antes de `✅ Bom`

## Dúvidas?

Abra uma [Discussion](https://github.com/melisource/fury_oh-my-claude/discussions) para conversar antes de implementar algo grande.
