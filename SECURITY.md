# Política de Segurança

## Versões suportadas

| Versão | Suportada |
|--------|-----------|
| 1.x    | ✅ Sim    |
| < 1.0  | ❌ Não    |

## Reportando uma vulnerabilidade

**Não abra uma issue pública para reportar vulnerabilidades de segurança.**

Se você encontrou um problema de segurança em `oh my claude`, por favor:

1. **Envie um e-mail** para: [security@deMGoncalves.dev](mailto:security@deMGoncalves.dev)
2. **Ou use** [GitHub Security Advisories](https://github.com/deMGoncalves/oh-my-claude/security/advisories/new) (privado)

### O que incluir no report

- Descrição do problema
- Passos para reproduzir
- Impacto potencial
- Sugestão de correção (se tiver)

### Processo

1. Você receberá uma confirmação em até **48 horas**
2. O problema será investigado e classificado
3. Uma correção será desenvolvida e testada
4. A vulnerabilidade será divulgada após o patch ser publicado

## Escopo

Este projeto é um **workflow de Claude Code CLI** com:

- **Hooks shell** (`lint.sh`, `loop.sh`, `prompt.sh`) — execução de comandos locais
- **MCPs configurados** (`.mcp.json`) — conexões a serviços externos
- **Agents e skills** — prompts injetados no contexto do Claude

### Áreas de atenção

- Injeção de comandos nos hooks
- Exposição de tokens/secrets no `.mcp.json` ou nos agents
- Execução arbitrária via hooks `PreToolUse`/`PostToolUse`

**Lembre-se:** Nunca commite tokens reais (Figma, GitHub) no `.mcp.json`. Use variáveis de ambiente.
