# Como Contribuir

Obrigado por querer contribuir com o **oh my claude**! Este projeto é um workflow de desenvolvimento assistido por IA — sua contribuição pode ajudar outros desenvolvedores a escrever código melhor com o Claude Code.

## O que você pode contribuir

| Tipo | Descrição | Onde fica |
|------|-----------|-----------|
| **Nova rule** | Regra arquitetural com critérios objetivos | `.claude/rules/` |
| **Nova skill** | Módulo de conhecimento para os agentes | `.claude/skills/` |
| **Novo command** | Comando invocável com `/nome` | `.claude/commands/` |
| **Melhoria de agent** | Refinamento de um agente existente | `.claude/agents/` |
| **Correção de bug** | Erro em hook, command ou agent | Onde o bug está |
| **Documentação** | Melhoria no README ou nos markdowns | Raiz do projeto |

---

## Adicionando uma Rule

Crie o arquivo em `.claude/rules/` seguindo o template:

```markdown
# [Título da Regra]

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

- [Quando a regra pode ser ignorada]

## Como Detectar

### Manual
[O que verificar no código]

### Automático
[Ferramenta e configuração: ESLint, Biome, SonarQube]

## Relacionada com

- [NNN - Nome da Rule](NNN_nome.md): [tipo de relação]

---

**Criada em**: AAAA-MM-DD  **Versão**: 1.0
```

**Regras para o ID:**
- Object Calisthenics: `001–009` (próximo: `010`)
- SOLID: `010–014`
- Package Principles: `015–020`
- Clean Code: `021–039`
- Twelve-Factor: `040–051`
- Anti-Patterns: `052–070`
- **Novas rules:** próximo ID disponível é `071`

---

## Adicionando uma Skill

Crie o diretório em `.claude/skills/nome-da-skill/` com `SKILL.md`:

```yaml
---
name: skill-name          # kebab-case
description: "[O que é]. Use quando [condição] — [triggers específicos]."
model: haiku               # haiku para referência rápida, sonnet para análise
allowed-tools: Read        # mínimo necessário
metadata:
  author: SeuNome
  version: "1.0.0"
---
```

**Estrutura do body:**
```
## Quando Usar
## [Conteúdo principal]
## Exemplos (❌ Ruim / ✅ Bom)
## Proibições
## Fundamentação  ← links para rules relacionadas
```

Para skills com muito conteúdo, use `references/`:
```
skill-name/
├── SKILL.md          ← índice leve
└── references/
    └── detalhe.md    ← conteúdo carregado sob demanda
```

---

## Adicionando um Command

Crie o arquivo em `.claude/commands/nome.md`:

```yaml
---
description: "[Uso principal em ≤ 250 chars, front-loaded]"
argument-hint: "[args esperados]"  # opcional
allowed-tools: Tool, Bash(comando específico *)
---

## Propósito

[1-2 linhas + contexto vivo com !`comando`]

## Instruções

1. [Passo 1]
2. [Passo 2]
```

---

## Processo de PR

1. **Fork** o repositório
2. **Crie uma branch** com nome descritivo:
   - `rule/071-nome-da-rule`
   - `skill/nome-da-skill`
   - `fix/descricao-do-bug`
3. **Implemente** seguindo os templates acima
4. **Adicione ao CHANGELOG.md** na seção `[Unreleased]`
5. **Abra um Pull Request** com o template preenchido

### Checklist de qualidade

Para **rules:**
- [ ] ID único e na categoria correta
- [ ] Critérios objetivos e mensuráveis (não subjetivos)
- [ ] Cross-references bidirecionais com rules relacionadas
- [ ] Severidade justificada

Para **skills:**
- [ ] Frontmatter completo com `metadata.author`
- [ ] Seção `## Exemplos` com ❌/✅
- [ ] `## Fundamentação` com links para rules
- [ ] Description com triggers específicos (≤ 250 chars)

Para **commands:**
- [ ] Testado com Claude Code CLI
- [ ] `allowed-tools` com mínimo de permissões
- [ ] Live context injection com `!`cmd`` onde aplicável
- [ ] `$ARGUMENTS` usado onde o command aceita args

---

## Padrões de código

- **Idioma:** português para documentação, inglês para código TypeScript
- **Nomes de arquivo:** `kebab-case`
- **Codetags:** educativos — explique o porquê, não só o quê
- **Exemplos:** sempre `❌ Ruim` antes de `✅ Bom`

## Dúvidas?

Abra uma [Discussion](https://github.com/deMGoncalves/oh-my-claude/discussions) para conversar antes de implementar algo grande.
